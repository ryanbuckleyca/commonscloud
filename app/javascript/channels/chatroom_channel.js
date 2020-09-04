import consumer from "./consumer";

const initChatroomCable = () => {
  const messagesContainer = document.querySelectorAll('.messages');
  if (messagesContainer) {
    messagesContainer.forEach((chatroom) => {
      const id = chatroom.dataset.chatroomId;

      consumer.subscriptions.create({ channel: "ChatroomChannel", id: id }, {
        received(data) {
          chatroom.querySelector("#message_content").value = ""
          const container = document.getElementById(`messages-${data.chatroom_id}`);
          container.querySelector('#new_message').insertAdjacentHTML('beforebegin', data.message);
        }
      });
    });
  }
}

export { initChatroomCable };
