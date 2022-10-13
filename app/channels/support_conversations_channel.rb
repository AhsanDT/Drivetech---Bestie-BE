class SupportConversationsChannel < ApplicationCable::Channel
  def subscribed
    # stop_all_streams
    SupportConversation.where(sender_id: current_user).or(SupportConversation.where(recipient_id: current_user)).find_each do |conversation|
      stream_from "support_conversations_#{conversation.id}"
   end
  end

  def unsubscribed
    stop_all_streams
  end
end
