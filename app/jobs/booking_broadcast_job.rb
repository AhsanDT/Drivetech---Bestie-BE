class BookingBroadcastJob < ApplicationJob
  queue_as :default

  def perform(booking)
    @conversation = Conversation.find_by(sender_id: booking.send_by_id, recipient_id: booking.send_to_id) || Conversation.find_by(sender_id: booking.send_to_id, recipient_id: booking.send_by_id)
    if @conversation.present?
      payload = {
        type: "booking",
        conversation_id: @conversation.id,
        sender_id: @conversation.sender.id,
        sender_name: @conversation.sender.first_name,
        recepient_id: @conversation.recepient.id,
        recepient_name: @conversation.recepient.first_name,
        sender_image: @conversation.sender.profile_image.attached? ? @conversation.sender.profile_image.url : "",
        recepient_image: @conversation.recepient.profile_image.attached? ? @conversation.recepient.profile_image.url : "",
        unread_messages: @conversation.messages.where(is_read: false).count,
        is_blocked: @conversation.is_blocked,
        user_id: booking.send_by_id,
        id: booking.id,
        start_time: booking.start_time,
        end_time: booking.end_time,
        rate: booking.rate,
        status: booking.status
      }
      ActionCable.server.broadcast(build_conversation_id(@conversation.id), payload)
    end
  end

  def build_conversation_id(id)
    "conversation_#{id}"
  end
end