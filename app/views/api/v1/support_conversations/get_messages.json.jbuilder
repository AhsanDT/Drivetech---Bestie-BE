json.data do
  json.(@messages)  do |message|
    json.message message
    json.message_image message.image.attached? ? message.image.blob.url : ''
    json.ticket_number message.support_conversation.support.ticket_number
  end
end
