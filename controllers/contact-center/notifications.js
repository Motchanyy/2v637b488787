const recipients = require("../notifications/recipients");
const connection_pool = require("../../config/database/connection_pool");
const config = require("../../config/config");
const logging = require("../../logging/logging");

const P = config.get("configDatabase").prefix;

// Ключ налаштувань: усі канали контакт-центру живуть під цим scope
const SCOPE = "contact_center.channel";

/** Отримувачі каналу — для сторінки налаштувань. Групи лишаються групами. */
async function list(idChannel, idLang) {
	return recipients.list(SCOPE, idChannel, idLang);
}

/** Повна заміна списку. conn — щоб зберігати в одній транзакції з каналом. */
async function save(conn, idChannel, items) {
	return recipients.save(conn, SCOPE, idChannel, items);
}

/**
 * Сповіщення про вхідне повідомлення.
 * Власної доставки немає: notifyScope() віддає кожну аудиторію в notify(),
 * а той уже робить резолв груп, дедуплікацію і чергу.
 */
async function notifyIncoming(conv, message, isNewConversation) {
	await recipients.notifyScope(
		SCOPE,
		conv.id_channel,
		{
			type: isNewConversation ? "contact_center.new_conversation" : "contact_center.new_message",
			channels: ["inapp"],
			collapseKey: "cc_conv_" + conv.id,
			priority: 5,
			payload: {
				title: conv.channel_name,
				name: conv.title,
				message: String(message.text || "").slice(0, 200),
				url: "/contact-center/chat/" + conv.url_token + "/",
				channel: conv.channel,
				date: new Date().toISOString().slice(0, 19).replace("T", " "),
			},
		},
		// Прапорці з UI каналу
		function (o) {
			return isNewConversation ? !!o.on_new_conversation : !!o.on_new_message;
		}
	);
}

/** Менеджер відкрив діалог — архівуємо сповіщення цього діалогу в системному інбоксі. */
async function markConversationRead(idConversation, idManager) {
	try {
		await connection_pool.query(
			`UPDATE ${P}notif_inbox
                SET read_at = COALESCE(read_at, NOW(3)), archived_at = NOW(3)
              WHERE user_id = ? AND collapse_key = ? AND archived_at IS NULL`,
			[idManager, "cc_conv_" + idConversation]
		);
	} catch (error) {
		logging.error(error);
	}
}

/** Видаляє всі сповіщення діалогу (при повному видаленні діалогу). */
async function deleteConversationNotifications(idConversation) {
	try {
		await connection_pool.query(`DELETE FROM ${P}notif_inbox WHERE collapse_key = ?`, ["cc_conv_" + idConversation]);
	} catch (error) {
		logging.error(error);
	}
}
	
/** Видаляє всі сповіщення діалогу (при повному видаленні діалогу). */
async function deleteConversationNotifications(idConversation) {
	try {
		await connection_pool.query(`DELETE FROM ${P}notif_inbox WHERE collapse_key = ?`, ["cc_conv_" + idConversation]);
	} catch (error) {
		logging.error(error);
	}
}

module.exports = { list, save, notifyIncoming, markConversationRead, deleteConversationNotifications };