const connection_pool = require("../../config/database/connection_pool");
const config = require("../../config/config");
const logging = require("../../logging/logging");
const { notify } = require("../notifications/notify");

const P = config.get("configDatabase").prefix;
const T_RECIPIENTS = P + "contact_center_channel_recipients";

/** Отримувачі каналу з іменами — для сторінки налаштувань. */
async function list(idChannel, idLang) {
	const lang = parseInt(idLang, 10) || 1;

	const [rows] = await connection_pool.query(
		`SELECT r.id, r.kind, r.ref, r.on_new_conversation, r.on_new_message,
                CASE r.kind
                    WHEN 'user'  THEN NULLIF(TRIM(CONCAT(COALESCE(u.first_name,''),' ',COALESCE(u.last_name,''))), '')
                    WHEN 'group' THEN COALESCE(gl.name, gl_any.name)
                    ELSE r.ref
                END AS name
         FROM ${T_RECIPIENTS} AS r
         LEFT JOIN ${P}users AS u
                ON r.kind = 'user' AND u.id = r.ref
         LEFT JOIN ${P}users_groups_lang AS gl
                ON r.kind = 'group' AND gl.id_group = r.ref AND gl.id_lang = ?
         LEFT JOIN ${P}users_groups_lang AS gl_any
                ON r.kind = 'group' AND gl_any.id_group = r.ref
         WHERE r.id_channel = ?
         ORDER BY r.kind, r.id`,
		[lang, idChannel]
	);

	return rows;
}

/**
 * Повна заміна списку отримувачів каналу.
 * Заміна, а не інкремент: UI віддає підсумковий стан.
 */
async function save(conn, idChannel, recipients) {
	await conn.execute(`DELETE FROM ${T_RECIPIENTS} WHERE id_channel = ?`, [idChannel]);

	if (!Array.isArray(recipients) || !recipients.length) return;

	for (const r of recipients) {
		if (["user", "group", "topic"].indexOf(r.kind) === -1) continue;

		const ref = String(r.ref || "").slice(0, 64);
		if (!ref) continue;

		await conn.execute(
			`INSERT IGNORE INTO ${T_RECIPIENTS}
                (id_channel, kind, ref, on_new_conversation, on_new_message)
             VALUES (?, ?, ?, ?, ?)`,
			[idChannel, r.kind, ref, r.on_new_conversation ? 1 : 0, r.on_new_message ? 1 : 0]
		);
	}
}

/**
 * Сповіщення про вхідне повідомлення.
 * Жодної власної доставки — усе через існуючий notify():
 * він сам резолвить групи, дедуплікує і кладе в чергу.
 *
 * collapseKey на діалог означає, що серія повідомлень від одного
 * клієнта згорнеться в одне сповіщення, а не завалить менеджера.
 */
async function notifyIncoming(conv, message, isNewConversation, count) {
	try {
		const [rows] = await connection_pool.query(
			`SELECT kind, ref FROM ${T_RECIPIENTS}
             WHERE id_channel = ? AND ${isNewConversation ? "on_new_conversation" : "on_new_message"} = 1`,
			[conv.id_channel]
		);

		if (!rows.length) return;

		const payload = {
			title: conv.channel_name,
			name: conv.title,
			message: String(message.text || "").slice(0, 200),
			url: "/contact-center/chat/" + conv.url_token + "/",
			channel: conv.channel,
			// Скільки непрочитаних у цьому діалозі — індикатор у списку сповіщень
			count: Number(count) || 1,
			date: new Date().toISOString().slice(0, 19).replace("T", " "),
		};

		for (const r of rows) {
			const audience = {};
			audience[r.kind] = r.ref;

			await notify({
				type: isNewConversation ? "contact_center.new_conversation" : "contact_center.new_message",
				audience: audience,
				channels: ["inapp"],
				payload: payload,
				collapseKey: "cc_conv_" + conv.id,
				priority: 5,
			}).catch(function (e) {
				logging.error(e);
			});
		}
	} catch (error) {
		// Збій сповіщення не має ламати прийом повідомлення
		console.error("cc notify:", error.message);
		logging.error(error);
	}
}

module.exports = { list, save, notifyIncoming };
