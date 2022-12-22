json.unread_messages @count
json.conversation @conversation
json.data do
  json.(@messages)  do |message|
    json.message message
    json.sender_id message.conversation.sender_id
    json.recipient_id message.conversation.recipient_id
    json.message_image message.image.attached? ? message.image.blob.url : ''
  end
end