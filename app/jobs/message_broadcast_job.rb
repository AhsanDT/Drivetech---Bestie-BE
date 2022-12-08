class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    payload = {
      type: "chat",
      id: message.id,
      body: message.body,
      conversation_id: message.conversation_id,
      read_status: message.is_read,
      sender_id: message.conversation.sender.id,
      sender_name: message.conversation.sender.first_name,
      recepient_id: message.conversation.recepient.id,
      recepient_name: message.conversation.recepient.first_name,
      created_at: message.created_at,
      message_image: message.image.attached? ? message.image.url : "",
      sender_image: message.conversation.sender.profile_image.attached? ? message.conversation.sender.profile_image.url : "",
      recepient_image: message.conversation.recepient.profile_image.attached? ? message.conversation.recepient.profile_image.url : "",
      unread_messages: message.conversation.messages.where(is_read: false).count,
      is_blocked: message.conversation.is_blocked
    }
    ActionCable.server.broadcast(build_conversation_id(message.conversation_id), payload)
  end
  
  def build_conversation_id(id)
    "conversation_#{id}"
  end
end