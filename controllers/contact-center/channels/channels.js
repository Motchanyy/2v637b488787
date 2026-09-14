const connection_pool = require("../../../config/database/connection_pool");
const config = require("../../../config/config");
const logging = require("../../../logging/logging");
const types = require("./index");
const ccNotifications = require("../notifications");

const P = config.get("configDatabase").prefix;
const TABLE = P + "contact_center_channels";

const channelsControllers = {
	// ── Сторінка списку ──
	page: (req, res) => {
		res.render("pages/contact-center/channels/index", {
			i18n: res,
			user: req.user,
			data: { types: types.meta() },
			header: { navbar: "contact-center" },
		});
	},

	// ── Дані для Tabulator ──
	// Ідентифікатор кожного типу тягнеться LEFT JOIN-ом по його таблиці.
	// Запит будується з реєстру — новий тип не вимагає правки цього коду.
	list: async (req, res) => {
		try {
			const joins = [];
			const cases = [];

			types.all().forEach(function (t, i) {
				const alias = "t" + i;
				joins.push(`LEFT JOIN ${t.table} AS ${alias} ON ${alias}.id_channel = c.id`);
				cases.push(`WHEN '${t.code}' THEN ${t.identitySql(alias)}`);
			});

			const [rows] = await connection_pool.query(
				`SELECT c.id, c.type, c.name, c.status, c.is_configured,
                        c.connection_status, c.connection_error, c.date_checked, c.date_add,
                        CASE c.type ${cases.join(" ")} ELSE '' END AS identity
                 FROM ${TABLE} AS c
                 ${joins.join("\n                 ")}
                 WHERE c.deleted = 0
                 ORDER BY c.sort_order ASC, c.id DESC`
			);

			res.status(200).json(rows);
		} catch (error) {
			console.error("channels list:", error.message);
			logging.error(error);
			res.status(500).json([]);
		}
	},

	// ── Створення з модалки ──
	create: async (req, res) => {
		const b = req.body || {};
		const type = String(b.type || "").trim();
		const name = String(b.name || "").trim();

		const errors = [];
		if (!types.get(type)) errors.push({ field: "type", message: "Оберіть тип каналу" });
		if (!name) errors.push({ field: "name", message: "Вкажіть назву каналу" });
		else if (name.length > 255) errors.push({ field: "name", message: "Назва задовга (макс. 255)" });

		if (errors.length) return res.status(400).json({ status: "error", errors });

		const conn = await connection_pool.getConnection();
		try {
			await conn.beginTransaction();

			const [r] = await conn.execute(`INSERT INTO ${TABLE} (type, name, id_user) VALUES (?, ?, ?)`, [type, name, req.user.userId]);

			// канал і його налаштування створюються атомарно
			await types.get(type).create(conn, r.insertId);

			await conn.commit();
			res.status(200).json({ status: "success", id: r.insertId });
		} catch (error) {
			await conn.rollback();
			console.error("channels create:", error.message);
			logging.error(error);
			res.status(500).json({ status: "error", errors: [{ message: "Помилка сервера" }] });
		} finally {
			conn.release();
		}
	},

	// ── Перемикач активності зі списку ──
	// Увімкнути можна лише налаштований канал — перевірка в самому UPDATE.
	status: async (req, res) => {
		const id = parseInt(req.params.id, 10);
		const status = req.body && req.body.status ? 1 : 0;
		if (!id) return res.status(400).json({ status: "error", message: "Невірний ID" });

		try {
			const [r] = await connection_pool.execute(`UPDATE ${TABLE} SET status = ?, id_user_edited = ? WHERE id = ? AND deleted = 0 AND (? = 0 OR is_configured = 1)`, [status, req.user.userId, id, status]);

			if (r.affectedRows === 0) {
				return res.status(400).json({ status: "error", message: "Канал не налаштовано" });
			}
			res.status(200).json({ status: "success" });
		} catch (error) {
			console.error("channels status:", error.message);
			logging.error(error);
			res.status(500).json({ status: "error" });
		}
	},

	// ── Сторінка редагування ──
	edit: async (req, res) => {
		const id = parseInt(req.params.id, 10);
		if (!id) return res.redirect("/contact-center/channels/");

		const conn = await connection_pool.getConnection();
		try {
			const [rows] = await conn.execute(`SELECT * FROM ${TABLE} WHERE id = ? AND deleted = 0 LIMIT 1`, [id]);
			if (!rows.length) return res.redirect("/contact-center/channels/");

			const channel = rows[0];
			const type = types.get(channel.type);
			if (!type) return res.redirect("/contact-center/channels/");

			const settings = await type.load(conn, id);
			const recipients = await ccNotifications.list(id, req.user && req.user.id_lang);

			res.render("pages/contact-center/channels/edit", {
				i18n: res,
				user: req.user,
				data: {
					channel: channel,
					settings: settings,
					meta: { code: type.code, label: type.label, icon: type.icon, color: type.color },
					typeView: type.view,
					recipients: recipients,
					appUrl: config.get("configServer").url,
				},
				header: { navbar: "contact-center" },
			});
		} catch (error) {
			console.error("channels edit:", error.message);
			logging.error(error);
			res.status(500).send("Internal Server Error");
		} finally {
			conn.release();
		}
	},

	// ── Збереження ──
	update: async (req, res) => {
		const id = parseInt(req.params.id, 10);
		if (!id) return res.status(400).json({ status: "error", errors: [{ message: "Невірний ID" }] });

		const conn = await connection_pool.getConnection();
		try {
			const [rows] = await conn.execute(`SELECT id, type FROM ${TABLE} WHERE id = ? AND deleted = 0 LIMIT 1`, [id]);
			if (!rows.length) return res.status(404).json({ status: "error", errors: [{ message: "Канал не знайдено" }] });

			const type = types.get(rows[0].type);
			if (!type) return res.status(400).json({ status: "error", errors: [{ message: "Невідомий тип каналу" }] });

			const b = req.body || {};
			const errors = [];

			// Спільна валідація
			const name = String(b.name || "").trim();
			if (!name) errors.push({ field: "name", message: "Вкажіть назву каналу" });
			else if (name.length > 255) errors.push({ field: "name", message: "Назва задовга (макс. 255)" });

			// Валідація типової частини — всередині типу
			const current = await type.load(conn, id);
			const typeCheck = type.validate(b, current);
			if (!typeCheck.valid) errors.push.apply(errors, typeCheck.errors);

			if (errors.length) return res.status(400).json({ status: "error", errors: errors });

			await conn.beginTransaction();

			const result = await type.save(conn, id, b, current);

			// Отримувачі сповіщень — спільні для всіх типів каналів
			await ccNotifications.save(conn, id, b.recipients);
			const configured = result.configured ? 1 : 0;

			// Увімкнути можна лише налаштований канал.
			// Якщо канал перестав бути налаштованим — вимикаємо і скидаємо стан перевірки.
			await conn.execute(
				`UPDATE ${TABLE}
                 SET name = ?,
                     status = IF(? = 1, ?, 0),
                     is_configured = ?,
                     connection_status = IF(? = 1, connection_status, 'unknown'),
                     connection_error = IF(? = 1, connection_error, NULL),
                     id_user_edited = ?
                 WHERE id = ?`,
				[name, configured, b.status ? 1 : 0, configured, configured, configured, req.user.userId, id]
			);

			await conn.commit();
			res.status(200).json({ status: "success", reload: !!result.reload });
		} catch (error) {
			await conn.rollback();
			console.error("channels update:", error.message);
			logging.error(error);
			res.status(500).json({ status: "error", errors: [{ message: "Помилка сервера" }] });
		} finally {
			conn.release();
		}
	},

	// ── Перевірка підключення ──
	test: async (req, res) => {
		const id = parseInt(req.params.id, 10);
		if (!id) return res.status(400).json({ ok: false, error: "Невірний ID" });

		const conn = await connection_pool.getConnection();
		try {
			const [rows] = await conn.execute(`SELECT type FROM ${TABLE} WHERE id = ? AND deleted = 0 LIMIT 1`, [id]);
			if (!rows.length) return res.status(404).json({ ok: false, error: "Канал не знайдено" });

			const type = types.get(rows[0].type);
			if (!type) return res.status(400).json({ ok: false, error: "Невідомий тип каналу" });

			const result = await type.test(conn, id);

			await conn.execute(
				`UPDATE ${TABLE}
                 SET connection_status = ?, connection_error = ?, date_checked = NOW(),
                     is_configured = ?, status = IF(? = 1, status, 0)
                 WHERE id = ?`,
				[result.ok ? "ok" : "error", result.ok ? null : result.error || null, result.ok ? 1 : 0, result.ok ? 1 : 0, id]
			);

			res.status(200).json(result);
		} catch (error) {
			console.error("channels test:", error.message);
			logging.error(error);
			res.status(500).json({ ok: false, error: "Помилка сервера" });
		} finally {
			conn.release();
		}
	},

	// ── М'яке видалення ──
	remove: async (req, res) => {
		const id = parseInt(req.params.id, 10);
		if (!id) return res.status(400).json({ status: "error", message: "Невірний ID" });

		try {
			const [r] = await connection_pool.execute(`UPDATE ${TABLE} SET deleted = 1, status = 0, date_deleted = NOW(), id_user_deleted = ? WHERE id = ? AND deleted = 0`, [req.user.userId, id]);

			if (r.affectedRows === 0) return res.status(404).json({ status: "error", message: "Канал не знайдено" });
			res.status(200).json({ status: "success" });
		} catch (error) {
			console.error("channels delete:", error.message);
			logging.error(error);
			res.status(500).json({ status: "error" });
		}
	},
};

module.exports = channelsControllers;
