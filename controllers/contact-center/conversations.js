const connection_pool = require("../../config/database/connection_pool");
const config = require("../../config/config");
const logging = require("../../logging/logging");
const types = require("./channels/index");
const model = require("./model");

const P = config.get("configDatabase").prefix;

const T_CONVS = P + "contact_center_conversations";
const T_CONTACTS = P + "contact_center_contacts";
const T_CHANNELS = P + "contact_center_channels";
const T_UNREAD = P + "contact_center_unread";

// Метадані типів каналів — щоб фронту не треба було нічого доганяти
const META = {};
types.all().forEach(function (t) {
	META[t.code] = { icon: t.icon, color: t.color, label: t.label };
});

const conversationsControllers = {
	// ── Список чатів ──
	// Один запит на всі канали. Новий канал нічого тут не змінює.
	list: async (req, res) => {
		try {
			const currentUserId = req.user.userId;

			const b = req.body || {};
			const view = b.view === "mine" ? "mine" : "all";
			const tab = ["open", "pending", "resolved", "archived"].indexOf(b.tab) !== -1 ? b.tab : "open";
			const limit = Math.min(Math.max(parseInt(b.limit, 10) || 30, 1), 100);

			const params = [currentUserId, tab];
			let where = "";

			if (view === "mine") {
				// Тільки мої діалоги
				where += " AND c.id_manager = ?";
				params.push(currentUserId);
			} else {
				// Спільна черга: нерозібрані + мої. Чужі не показуємо.
				where += " AND (c.id_manager IS NULL OR c.id_manager = ?)";
				params.push(currentUserId);
			}

			// Курсорна пагінація: (date_last_message, id) — пара унікальна і монотонна
			const cursorDate = b.cursorDate ? String(b.cursorDate) : null;
			const cursorId = b.cursorId ? parseInt(b.cursorId, 10) : null;

			if (cursorDate && cursorId) {
				where += ` AND (c.date_last_message < CAST(? AS DATETIME(3))
                           OR (c.date_last_message = CAST(? AS DATETIME(3)) AND c.id < ?))`;
				params.push(cursorDate, cursorDate, cursorId);
			}

			const [rows] = await connection_pool.query(
				`SELECT
                    c.id, c.url_token, c.status, c.id_manager,
                    c.last_message_text, c.last_message_type, c.last_message_dir,
                    c.date_last_message,
                    ch.type AS channel, ch.name AS channel_name, ch.status AS channel_active,
                    ct.name AS contact_name, ct.username AS contact_username, ct.avatar AS contact_avatar,
                    COALESCE(ur.count, 0) AS count
                 FROM ${T_CONVS} AS c
                 INNER JOIN ${T_CHANNELS} AS ch ON ch.id = c.id_channel
                 INNER JOIN ${T_CONTACTS} AS ct ON ct.id = c.id_contact
                 LEFT JOIN ${T_UNREAD} AS ur ON ur.id_conversation = c.id AND ur.id_manager = ?
                 WHERE ch.deleted = 0 AND c.status = ? ${where}
                 ORDER BY c.date_last_message DESC, c.id DESC
                 LIMIT ${limit}`,
				params
			);

			const hasMore = rows.length === limit;

			const items = rows.map(function (r) {
				const meta = META[r.channel] || {};

				return {
					id: r.id,
					url_token: r.url_token,
					channel: r.channel,
					channel_name: r.channel_name,
					channel_icon: meta.icon || "",
					channel_color: meta.color || "#6c757d",
					channel_active: Number(r.channel_active) === 1 ? 1 : 0,
					title: r.contact_name || (r.contact_username ? "@" + r.contact_username : "—"),
					avatar: r.contact_avatar || "",
					preview: r.last_message_text || "",
					preview_dir: r.last_message_dir || "in",
					last_at: r.date_last_message,
					count: r.count | 0,
					// 0 — нерозібраний, 1 — мій
					status: r.id_manager === null ? 0 : 1,
				};
			});

			const last = rows[rows.length - 1];

			res.status(200).json({
				items: items,
				nextCursorDate: hasMore && last ? String(last.date_last_message) : null,
				nextCursorId: hasMore && last ? last.id : null,
			});
		} catch (error) {
			console.error("conversations list:", error.message);
			logging.error(error);
			res.status(500).json({ error: "server_error" });
		}
	},

		// ── Сторінка діалогу ──
	page: async (req, res) => {
		const token = String(req.params.token || "");

		// url_token — рівно 32 hex
		if (!/^[a-f0-9]{32}$/.test(token)) return res.redirect("/contact-center/");

		try {
			const conv = await model.getConversationByToken(token);
			if (!conv) return res.redirect("/contact-center/");

			const type = types.get(conv.channel_type);

			res.render("pages/contact-center/contact-center/dialog", {
				i18n: res,
				user: req.user,
				data: {
					conversation: conv,
					meta: type ? { icon: type.icon, color: type.color, label: type.label } : { icon: "", color: "#6c757d", label: "" },
				},
				header: { navbar: "contact-center" },
			});
		} catch (error) {
			console.error("conversation page:", error.message);
			logging.error(error);
			res.status(500).send("Internal Server Error");
		}
	},

	// ── Стрічка повідомлень ──
	messages: async (req, res) => {
		const id = parseInt(req.params.id, 10);
		if (!id) return res.status(400).json({ error: "bad_id" });

		try {
			const result = await model.getMessages(id, req.body && req.body.before, req.body && req.body.limit);

			// Відкрив діалог — непрочитані обнуляються
			await model.markRead(id, req.user.userId);

			res.status(200).json(result);
		} catch (error) {
			console.error("conversation messages:", error.message);
			logging.error(error);
			res.status(500).json({ error: "server_error" });
		}
	},

	// ── Відправка повідомлення ──
	// Порядок навмисний: спершу запис у БД зі status='pending',
	// потім виклик API каналу, потім markSent/markFailed.
	// Збій відправки лишається видимим станом, а не втратою повідомлення.
	send: async (req, res) => {
		const id = parseInt(req.params.id, 10);
		const text = String((req.body && req.body.text) || "").trim();

		if (!id) return res.status(400).json({ status: "error", message: "Невірний ID" });
		if (!text) return res.status(400).json({ status: "error", message: "Порожнє повідомлення" });
		if (text.length > 4000) return res.status(400).json({ status: "error", message: "Повідомлення задовге" });

		try {
			const [rows] = await connection_pool.query(
				`SELECT c.id, c.id_channel, c.source_thread_id, ct.external_id,
                        ch.type AS channel_type, ch.status AS channel_active
                 FROM ${T_CONVS} AS c
                 INNER JOIN ${T_CONTACTS} AS ct ON ct.id = c.id_contact
                 INNER JOIN ${T_CHANNELS} AS ch ON ch.id = c.id_channel
                 WHERE c.id = ? AND ch.deleted = 0 LIMIT 1`,
				[id]
			);

			if (!rows.length) return res.status(404).json({ status: "error", message: "Діалог не знайдено" });

			const conv = rows[0];
			if (Number(conv.channel_active) !== 1) {
				return res.status(400).json({ status: "error", message: "Канал вимкнено" });
			}

			const type = types.get(conv.channel_type);
			if (!type || typeof type.send !== "function") {
				return res.status(400).json({ status: "error", message: "Канал не підтримує відправку" });
			}

			// 1. Запис у БД
			const saved = await model.addOutgoing({
				id_conversation: conv.id,
				id_manager: req.user.userId,
				message: { type: "text", text: text },
			});

			// 2. Відправка в канал
			const target = conv.source_thread_id || conv.external_id;
			const conn = await connection_pool.getConnection();
			let result;
			try {
				result = await type.send(conn, conv.id_channel, target, { text: text });
			} finally {
				conn.release();
			}

			// 3. Фіксація результату
			if (result.ok) {
				await model.markSent(saved.id_message, result.source_id);
			} else {
				await model.markFailed(saved.id_message, result.error);
			}

			res.status(200).json({
				status: result.ok ? "success" : "error",
				id_message: saved.id_message,
				date_add: saved.date_add,
				message: result.ok ? null : result.error,
			});
		} catch (error) {
			console.error("conversation send:", error.message);
			logging.error(error);
			res.status(500).json({ status: "error", message: "Помилка сервера" });
		}
	},

	// ── Взяти в роботу / звільнити ──
	assign: async (req, res) => {
		const id = parseInt(req.params.id, 10);
		if (!id) return res.status(400).json({ status: "error" });

		// take — призначити собі, release — зняти
		const take = !(req.body && req.body.release);

		try {
			await model.assignManager(id, take ? req.user.userId : null);
			res.status(200).json({ status: "success", id_manager: take ? req.user.userId : null });
		} catch (error) {
			console.error("conversation assign:", error.message);
			logging.error(error);
			res.status(500).json({ status: "error" });
		}
	},

	// ── Зміна статусу ──
	status: async (req, res) => {
		const id = parseInt(req.params.id, 10);
		const status = String((req.body && req.body.status) || "");

		if (!id) return res.status(400).json({ status: "error" });
		if (["open", "pending", "resolved", "archived"].indexOf(status) === -1) {
			return res.status(400).json({ status: "error", message: "Невідомий статус" });
		}

		try {
			await model.setStatus(id, status);
			res.status(200).json({ status: "success" });
		} catch (error) {
			console.error("conversation status:", error.message);
			logging.error(error);
			res.status(500).json({ status: "error" });
		}
	},

	// ── Лічильники для вкладок ──
	// Окремим запитом, щоб список не тягнув COUNT на кожне оновлення.
	counters: async (req, res) => {
		try {
			const currentUserId = req.user.userId;

			const [rows] = await connection_pool.query(
				`SELECT c.status,
                        COUNT(*) AS total,
                        SUM(CASE WHEN c.id_manager = ? THEN 1 ELSE 0 END) AS mine,
                        SUM(CASE WHEN c.id_manager IS NULL THEN 1 ELSE 0 END) AS unassigned,
                        COALESCE(SUM(ur.count), 0) AS unread
                 FROM ${T_CONVS} AS c
                 INNER JOIN ${T_CHANNELS} AS ch ON ch.id = c.id_channel
                 LEFT JOIN ${T_UNREAD} AS ur ON ur.id_conversation = c.id AND ur.id_manager = ?
                 WHERE ch.deleted = 0
                   AND (c.id_manager IS NULL OR c.id_manager = ?)
                 GROUP BY c.status`,
				[currentUserId, currentUserId, currentUserId]
			);

			const out = { open: 0, pending: 0, resolved: 0, archived: 0, unread: 0 };

			rows.forEach(function (r) {
				out[r.status] = Number(r.total) || 0;
				out.unread += Number(r.unread) || 0;
			});

			res.status(200).json(out);
		} catch (error) {
			console.error("conversations counters:", error.message);
			logging.error(error);
			res.status(500).json({ open: 0, pending: 0, resolved: 0, archived: 0, unread: 0 });
		}
	},
};

module.exports = conversationsControllers;