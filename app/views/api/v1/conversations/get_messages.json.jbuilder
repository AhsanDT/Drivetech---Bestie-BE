json.unread_messages @count
json.conversation @conversation
json.data do
  json.(@combine_booking)  do |message|
    if message.class == Message
      json.id message.id
      json.body message.body
      json.user_id message.user_id
      json.conversation_id message.conversation_id
      json.is_read message.is_read
      json.created_at message.created_at
      json.updated_at message.updated_at
      json.sender_id message.conversation.sender_id
      json.recipient_id message.conversation.recipient_id
      json.message_image message.image.attached? ? message.image.blob.url : ''
    elsif message.class == Booking
      json.id message.id
      json.rate message.rate
      json.send_to_id message.send_to_id
      json.user_id message.send_by_id
      json.status message.status
      json.created_at message.created_at
      json.updated_at message.updated_at
      json.start_time message.start_time
      json.end_time message.end_time
    end
  end
end