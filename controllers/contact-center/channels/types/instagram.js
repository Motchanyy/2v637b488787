const axios = require("axios");
const config = require("../../../../config/config");
const cryptoHelper = require("../../../../helpers/crypto");

const P = config.get("configDatabase").prefix;
const TABLE = P + "contact_center_channel_instagram";

const GRAPH = "https://graph.instagram.com/v23.0";

module.exports = {
	code: "instagram",
	label: "contact_center.channels.type_instagram",
	icon: "fa-brands fa-instagram",
	color: "#e1306c",
	view: "./types/instagram",
	table: TABLE,

	async create(conn, idChannel) {
		await conn.execute(`INSERT INTO ${TABLE} (id_channel, verify_token) VALUES (?, ?)`, [idChannel, cryptoHelper.random(32)]);
	},

	async load(conn, idChannel) {
		const [rows] = await conn.execute(
			`SELECT id, ig_user_id, ig_username, ig_account_type, ig_profile_picture,
                    token_type, date_token_expires, date_token_refresh, app_id, verify_token,
                    app_secret_cipher
             FROM ${TABLE} WHERE id_channel = ? LIMIT 1`,
			[idChannel]
		);

		const r = rows[0] || {};
		return Object.assign({}, r, {
			has_token: !!r.ig_user_id || !!r.date_token_refresh,
			has_app_secret: !!r.app_secret_cipher,
			token_mask: "••••••••••••",
			app_secret_mask: r.app_secret_cipher ? "••••••••••••" : "",
		});
	},

	validate(body, current) {
		const errors = [];
		const token = String(body.token || "").trim();

		if (!token && !current.has_token) {
			errors.push({ field: "token", message: "Access token обов'язковий" });
		} else if (token && token.length < 30) {
			errors.push({ field: "token", message: "Токен виглядає некоректним" });
		}

		const appId = String(body.app_id || "").trim();
		if (appId && !/^\d{5,32}$/.test(appId)) {
			errors.push({ field: "app_id", message: "App ID має складатися з цифр" });
		}

		const appSecret = String(body.app_secret || "").trim();
		if (appSecret && appSecret.length < 16) {
			errors.push({ field: "app_secret", message: "App Secret виглядає некоректним" });
		}

		return { valid: errors.length === 0, errors: errors };
	},

	async save(conn, idChannel, body, current) {
		const token = String(body.token || "").trim();
		const appId = String(body.app_id || "").trim() || null;

		await conn.execute(`UPDATE ${TABLE} SET app_id = ? WHERE id_channel = ?`, [appId, idChannel]);

		// App Secret: порожнє поле = "не змінювати". Зберігаємо шифровано.
		const appSecret = String(body.app_secret || "").trim();
		if (appSecret) {
			const encS = cryptoHelper.encrypt(appSecret);
			await conn.execute(`UPDATE ${TABLE} SET app_secret_cipher = ?, app_secret_iv = ?, app_secret_tag = ? WHERE id_channel = ?`, [encS.cipher, encS.iv, encS.tag, idChannel]);
		}

		if (!token) return { configured: current.has_token, reload: false };

		const enc = cryptoHelper.encrypt(token);

		await conn.execute(
			`UPDATE ${TABLE}
             SET token_cipher = ?, token_iv = ?, token_tag = ?,
                 token_type = 'long_lived', date_token_refresh = NOW(),
                 ig_user_id = NULL, ig_username = NULL, ig_account_type = NULL
             WHERE id_channel = ?`,
			[enc.cipher, enc.iv, enc.tag, idChannel]
		);

		return { configured: false, reload: true };
	},

	async test(conn, idChannel) {
		const [rows] = await conn.execute(`SELECT token_cipher, token_iv, token_tag FROM ${TABLE} WHERE id_channel = ? LIMIT 1`, [idChannel]);

		const r = rows[0];
		const token = r && cryptoHelper.decrypt(r.token_cipher, r.token_iv, r.token_tag);
		if (!token) return { ok: false, error: "Токен не задано" };

		try {
			const response = await axios.get(`${GRAPH}/me`, {
				params: { fields: "user_id,username,account_type,profile_picture_url", access_token: token },
				timeout: 10000,
			});

			const d = response.data;
			const igId = d && (d.user_id || d.id);
			if (!igId) return { ok: false, error: "Instagram не повернув дані акаунта" };

			await conn.execute(`UPDATE ${TABLE} SET ig_user_id = ?, ig_username = ?, ig_account_type = ?, ig_profile_picture = ? WHERE id_channel = ?`, [igId, d.username || null, d.account_type || null, d.profile_picture_url || null, idChannel]);

			return { ok: true };
		} catch (e) {
			const msg = (e.response && e.response.data && e.response.data.error && e.response.data.error.message) || e.message;
			return { ok: false, error: String(msg).slice(0, 500) };
		}
	},

	async send(conn, idChannel, target, message) {
		const [rows] = await conn.execute(`SELECT token_cipher, token_iv, token_tag, ig_user_id FROM ${TABLE} WHERE id_channel = ? LIMIT 1`, [idChannel]);

		const r = rows[0];
		const token = r && cryptoHelper.decrypt(r.token_cipher, r.token_iv, r.token_tag);
		if (!token) return { ok: false, error: "Токен каналу не задано" };
		if (!r.ig_user_id) return { ok: false, error: "Канал не перевірено" };

		try {
			const response = await axios.post(
				`${GRAPH}/me/messages`,
				{
					recipient: { id: target },
					message: { text: message.text },
				},
				{
					params: { access_token: token },
					timeout: 15000,
				}
			);

			const data = response.data;
			if (!data || !data.message_id) return { ok: false, error: "Instagram не повернув ID повідомлення" };

			return { ok: true, source_id: String(data.message_id) };
		} catch (e) {
			const msg = (e.response && e.response.data && e.response.data.error && e.response.data.error.message) || e.message;
			return { ok: false, error: String(msg).slice(0, 500) };
		}
	},

	// ── Резолв каналу по ig_user_id (== entry.id з вебхука) ──
	// Повертає id_channel, розшифровані token і app_secret, verify_token, статус.
	// Використовується вхідним вебхуком.
	async resolveByIgUserId(conn, igUserId) {
		const [rows] = await conn.execute(
			`SELECT ig.id_channel, ig.verify_token,
                    ig.token_cipher, ig.token_iv, ig.token_tag,
                    ig.app_secret_cipher, ig.app_secret_iv, ig.app_secret_tag,
                    ch.status AS channel_active, ch.deleted
             FROM ${TABLE} AS ig
             INNER JOIN ${P}contact_center_channels AS ch ON ch.id = ig.id_channel
             WHERE ig.ig_user_id = ? AND ig.date_deleted IS NULL AND ch.deleted = 0
             LIMIT 1`,
			[String(igUserId)]
		);

		const r = rows[0];
		if (!r) return null;

		return {
			id_channel: r.id_channel,
			active: Number(r.channel_active) === 1,
			verify_token: r.verify_token || "",
			token: cryptoHelper.decrypt(r.token_cipher, r.token_iv, r.token_tag),
			app_secret: cryptoHelper.decrypt(r.app_secret_cipher, r.app_secret_iv, r.app_secret_tag),
		};
	},

	// ── Пошук verify_token для GET-верифікації ──
	// Meta б'є в один URL; verify_token у нас per-channel, тож шукаємо збіг.
	async findByVerifyToken(conn, verifyToken) {
		if (!verifyToken) return null;
		const [rows] = await conn.execute(`SELECT id_channel FROM ${TABLE} WHERE verify_token = ? AND date_deleted IS NULL LIMIT 1`, [String(verifyToken)]);
		return rows[0] ? { id_channel: rows[0].id_channel } : null;
	},

	// ── Нормалізація вебхук-події Instagram → канонічна форма моделі ──
	// entry — елемент payload.entry[]; ev — елемент entry.messaging[].
	// Повертає null, якщо подія нас не стосується (echo, реакції, read, порожнє).
	normalize(entry, ev) {
		if (!ev || !ev.message) return null;

		const msg = ev.message;

		// Echo нашого ж вихідного — не дублюємо
		if (msg.is_echo) return null;

		const senderId = ev.sender && ev.sender.id ? String(ev.sender.id) : null;
		if (!senderId) return null;

		const attachments = [];
		let type = "text";
		let text = msg.text || null;

		// Етап 1: медіа не завантажуємо, лише позначаємо тип у прев'ю.
		// (Повноцінні вкладення — Етап 2.)
		if (msg.attachments && msg.attachments.length) {
			const a = msg.attachments[0];
			const t = a.type;
			if (t === "image" || t === "story_mention" || t === "ig_reel" || t === "video" || t === "audio" || t === "file" || t === "share") {
				type = "media";
				if (!text) {
					text = t === "image" ? "[зображення]" : t === "video" || t === "ig_reel" ? "[відео]" : t === "audio" ? "[аудіо]" : t === "share" ? "[допис]" : t === "story_mention" ? "[згадка в історії]" : "[вкладення]";
				}
			} else {
				type = "text";
				if (!text) text = "[вкладення]";
			}
		}

		if (!text && !attachments.length) return null;

		const tsMs = Number(ev.timestamp) || Date.now();

		return {
			contact: {
				external_id: senderId,
				first_name: null,
				last_name: null,
				username: null,
			},
			source_thread_id: senderId,
			message: {
				source_id: String(msg.mid || ""),
				type: type,
				subtype: null,
				text: text,
				attachments: attachments,
				date_add: new Date(tsMs),
			},
		};
	},

	identitySql(alias) {
		return `CONCAT('@', COALESCE(${alias}.ig_username, ''))`;
	},
};