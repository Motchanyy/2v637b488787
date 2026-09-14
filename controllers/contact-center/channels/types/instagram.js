const axios = require("axios");
const config = require("../../../../config/config");
const cryptoHelper = require("../../../../helpers/crypto");

const P = config.get("configDatabase").prefix;
const TABLE = P + "contact_center_channel_instagram";

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
                    token_type, date_token_expires, date_token_refresh, app_id, verify_token
             FROM ${TABLE} WHERE id_channel = ? LIMIT 1`,
			[idChannel]
		);

		const r = rows[0] || {};
		return Object.assign({}, r, {
			has_token: !!r.ig_user_id || !!r.date_token_refresh,
			token_mask: "••••••••••••",
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

		return { valid: errors.length === 0, errors: errors };
	},

	async save(conn, idChannel, body, current) {
		const token = String(body.token || "").trim();
		const appId = String(body.app_id || "").trim() || null;

		await conn.execute(`UPDATE ${TABLE} SET app_id = ? WHERE id_channel = ?`, [appId, idChannel]);

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
			const response = await axios.get("https://graph.instagram.com/v21.0/me", {
				params: { fields: "id,username,account_type,profile_picture_url", access_token: token },
				timeout: 10000,
			});

			const d = response.data;
			if (!d || !d.id) return { ok: false, error: "Instagram не повернув дані акаунта" };

			await conn.execute(`UPDATE ${TABLE} SET ig_user_id = ?, ig_username = ?, ig_account_type = ?, ig_profile_picture = ? WHERE id_channel = ?`, [d.id, d.username || null, d.account_type || null, d.profile_picture_url || null, idChannel]);

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
				`https://graph.instagram.com/v21.0/${r.ig_user_id}/messages`,
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

	identitySql(alias) {
		return `CONCAT('@', COALESCE(${alias}.ig_username, ''))`;
	},
};
