json.unread_messages @count
json.conversation @conversation
json.data do
  json.(@messages)  do |message|
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
  end
end