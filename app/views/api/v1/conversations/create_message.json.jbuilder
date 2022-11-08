json.message @message
json.message_image @message.image.attached? ? @message.image.blob.url : ''