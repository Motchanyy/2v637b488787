const express = require("express");
const router = express.Router();

const connection_pool = require("../../../config/database/connection_pool");
const config = require("../../../config/config");
const logging = require("../../../logging/logging");
const types = require("../../../controllers/contact-center/channels/index");
const model = require("../../../controllers/contact-center/model");
const realtime = require("../../../controllers/contact-center/realtime");
const ccNotifications = require("../../../controllers/contact-center/notifications");

const P = config.get("configDatabase").prefix;

// Спільна обробка нормалізованого повідомлення
async function handleIncoming(idChannel, channelType, normalized) {
	if (!normalized) return;

	const result = await model.addIncoming({
		id_channel: idChannel,
		contact: normalized.contact,
		source_thread_id: normalized.source_thread_id,
		message: normalized.message,
	});

	// Повтор вебхука — нічого не робимо
	if (result.duplicate) return;

	const [rows] = await connection_pool.query(
		`SELECT c.id, c.id_channel, c.url_token, c.id_manager, c.status, c.messages_count,
                c.last_message_text, c.last_message_dir, c.date_last_message,
                ch.type AS channel, ch.name AS channel_name, ch.status AS channel_active,
                ct.name AS contact_name, ct.username AS contact_username,
				0 AS count
         FROM ${P}contact_center_conversations AS c
         INNER JOIN ${P}contact_center_channels AS ch ON ch.id = c.id_channel
         INNER JOIN ${P}contact_center_contacts AS ct ON ct.id = c.id_contact
         LEFT JOIN ${P}contact_center_unread AS ur ON ur.id_conversation = c.id AND ur.id_manager = c.id_manager
         WHERE c.id = ? LIMIT 1`,
		[result.id_conversation]
	);

	if (!rows.length) return;

	const r = rows[0];
	const meta = types.get(r.channel) || {};

	// Сповіщення менеджерам — після socket, поза критичним шляхом
	ccNotifications
		.notifyIncoming(
			{
				id: r.id,
				id_channel: r.id_channel,
				url_token: r.url_token,
				channel: r.channel,
				channel_name: r.channel_name,
				title: r.contact_name || (r.contact_username ? "@" + r.contact_username : "—"),
			},
			normalized.message,
			// Новий діалог — якщо це перше повідомлення або діалог відкрили заново
			result.reopened || Number(r.messages_count) <= 1
		)
		.catch(function (e) {
			console.error("cc notify:", e.message);
		});

	realtime.message({
		direction: "in",
		reopened: result.reopened,
		conversation: {
			id: r.id,
			url_token: r.url_token,
			channel: r.channel,
			channel_name: r.channel_name,
			channel_icon: meta.icon || "",
			channel_color: meta.color || "#6c757d",
			channel_active: Number(r.channel_active) === 1 ? 1 : 0,
			title: r.contact_name || (r.contact_username ? "@" + r.contact_username : "—"),
			preview: r.last_message_text || "",
			preview_dir: r.last_message_dir || "in",
			last_at: r.date_last_message,
			count: r.count | 0,
			status: r.id_manager === null ? 0 : 1,
			id_manager: r.id_manager,
		},
		message: Object.assign({ id: result.id_message, direction: "in", status: "delivered" }, normalized.message, {
			attachments: normalized.message.attachments || [],
			date_add: new Date(normalized.message.date_add || Date.now()).toISOString().slice(0, 19).replace("T", " "),
		}),
	});
}

// ── Telegram ──
// Секрет у шляху: один URL на канал, чужий запит не пройде.
router.post(["/api/contact-center/webhook/telegram/:secret/", "/api/contact-center/webhook/telegram/:secret"], async (req, res) => {
	const secret = String(req.params.secret || "");
	if (!/^[a-f0-9]{64}$/.test(secret)) return res.sendStatus(403);

	// Відповідаємо одразу: Telegram повторює вебхук, якщо чекає довше 60с
	res.sendStatus(200);

	try {
		const [rows] = await connection_pool.query(
			`SELECT t.id_channel, ch.status
             FROM ${P}contact_center_channel_telegram AS t
             INNER JOIN ${P}contact_center_channels AS ch ON ch.id = t.id_channel
             WHERE t.webhook_secret = ? AND ch.deleted = 0 AND t.date_deleted IS NULL
             LIMIT 1`,
			[secret]
		);

		if (!rows.length) return;
		if (Number(rows[0].status) !== 1) return;

		const type = types.get("telegram");
		await handleIncoming(rows[0].id_channel, "telegram", type.normalize(req.body || {}));
	} catch (error) {
		console.error("telegram webhook:", error.message);
		logging.error(error);
	}
});

module.exports = router;
