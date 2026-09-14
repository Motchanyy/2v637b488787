const config = require("../../../../config/config");
const cryptoHelper = require("../../../../helpers/crypto");

const P = config.get("configDatabase").prefix;
const TABLE = P + "contact_center_channel_webchat";

const HEX_COLOR = /^#[0-9a-fA-F]{6}$/;

module.exports = {
	code: "webchat",
	label: "contact_center.channels.type_webchat",
	icon: "fa-solid fa-globe",
	color: "#16a34a",
	view: "./types/webchat",
	table: TABLE,

	async create(conn, idChannel) {
		await conn.execute(`INSERT INTO ${TABLE} (id_channel, widget_key, widget_secret) VALUES (?, ?, ?)`, [idChannel, cryptoHelper.random(16), cryptoHelper.random(32)]);
	},

	async load(conn, idChannel) {
		const [rows] = await conn.execute(
			`SELECT id, widget_key, allowed_origins, title, subtitle,
                    welcome_message, offline_message, color_primary, color_accent,
                    position, avatar, require_name, require_email, require_phone
             FROM ${TABLE} WHERE id_channel = ? LIMIT 1`,
			[idChannel]
		);

		const r = rows[0] || {};
		return Object.assign({}, r, { has_token: true });
	},

	validate(body) {
		const errors = [];

		const origins = String(body.allowed_origins || "").trim();
		if (!origins) {
			errors.push({ field: "allowed_origins", message: "Вкажіть хоча б один домен" });
		} else if (origins.length > 5000) {
			errors.push({ field: "allowed_origins", message: "Список доменів задовгий" });
		} else {
			// Кожен домен окремо: без схеми, без шляху
			const bad = origins
				.split(",")
				.map(function (d) {
					return d.trim();
				})
				.filter(function (d) {
					return d && !/^[a-z0-9.-]+\.[a-z]{2,}$/i.test(d);
				});

			if (bad.length) {
				errors.push({ field: "allowed_origins", message: "Некоректний домен: " + bad[0] });
			}
		}

		if (body.color_primary && !HEX_COLOR.test(body.color_primary)) {
			errors.push({ field: "color_primary", message: "Невірний формат кольору" });
		}
		if (body.color_accent && !HEX_COLOR.test(body.color_accent)) {
			errors.push({ field: "color_accent", message: "Невірний формат кольору" });
		}
		if (body.position && ["right", "left"].indexOf(body.position) === -1) {
			errors.push({ field: "position", message: "Невірне положення віджета" });
		}

		return { valid: errors.length === 0, errors: errors };
	},

	async save(conn, idChannel, body) {
		// Нормалізація доменів: тримаємо у БД чистий список через кому
		const origins = String(body.allowed_origins || "")
			.split(",")
			.map(function (d) {
				return d.trim().toLowerCase();
			})
			.filter(Boolean)
			.join(",");

		await conn.execute(
			`UPDATE ${TABLE}
             SET allowed_origins = ?, title = ?, subtitle = ?,
                 welcome_message = ?, offline_message = ?,
                 color_primary = ?, color_accent = ?, position = ?,
                 require_name = ?, require_email = ?, require_phone = ?
             WHERE id_channel = ?`,
			[origins, String(body.title || "").slice(0, 255) || null, String(body.subtitle || "").slice(0, 255) || null, String(body.welcome_message || "") || null, String(body.offline_message || "") || null, HEX_COLOR.test(body.color_primary) ? body.color_primary : "#0d3b66", HEX_COLOR.test(body.color_accent) ? body.color_accent : "#f4a261", body.position === "left" ? "left" : "right", body.require_name ? 1 : 0, body.require_email ? 1 : 0, body.require_phone ? 1 : 0, idChannel]
		);

		// Веб-чат готовий одразу після вказання доменів
		return { configured: !!origins, reload: false };
	},

	async test(conn, idChannel) {
		const [rows] = await conn.execute(`SELECT allowed_origins, widget_key FROM ${TABLE} WHERE id_channel = ? LIMIT 1`, [idChannel]);

		const r = rows[0];
		if (!r || !r.widget_key) return { ok: false, error: "Ключ віджета не згенеровано" };
		if (!r.allowed_origins) return { ok: false, error: "Не вказано жодного дозволеного домену" };

		return { ok: true };
	},

	// Веб-чат не має зовнішнього API: повідомлення доставляється сокетом.
	// Саму подію шле контролер діалогу, тут лише підтверджуємо запис.
	async send(conn, idChannel, target, message) {
		return { ok: true, source_id: null, via_socket: true };
	},

	identitySql(alias) {
		return `COALESCE(SUBSTRING_INDEX(${alias}.allowed_origins, ',', 1), '')`;
	},
};
