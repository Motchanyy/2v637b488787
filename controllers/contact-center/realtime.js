// Єдина точка розсилки подій контакт-центру.
// Формат подій однаковий для всіх каналів — фронт не знає, звідки повідомлення.

const { getIO } = require("../socket/socket");

function io() {
	try {
		return getIO() || null;
	} catch (e) {
		return null;
	}
}

module.exports = {
	// Нове повідомлення: у список чатів і у відкритий діалог
	message(payload) {
		const server = io();
		if (!server) return;

		server.to("io_alert_contact_center").emit("cc:message", payload);
		server.to("io_conversation_" + payload.conversation.id).emit("cc:message", payload);

		if (payload.conversation.id_manager) {
			server.to("io_manager_" + payload.conversation.id_manager).emit("cc:message", payload);
		}
	},

	// Зміна статусу діалогу
	conversationStatus(id, status) {
		const server = io();
		if (!server) return;
		server.to("io_alert_contact_center").emit("cc:conversation_status", { id: id, status: status });
	},

	// Діалог пішов іншому менеджеру
	conversationRemoved(id, idManager) {
		const server = io();
		if (!server) return;
		server.to("io_manager_" + idManager).emit("cc:conversation_removed", { id: id });
	},

	// Файл довантажився — підміна заглушки в діалозі
	attachmentReady(idConversation, idMessage, sortOrder, attachment) {
		const server = io();
		if (!server) return;

		server.to("io_conversation_" + idConversation).emit("cc:attachment_ready", {
			id_message: idMessage,
			sort_order: sortOrder,
			attachment: attachment,
		});
	},

	// Онлайн-статус співрозмовника
	presence(idConversation, online) {
		const server = io();
		if (!server) return;
		server.to("io_alert_contact_center").emit("cc:presence", { id: idConversation, online: !!online });
	},
};
