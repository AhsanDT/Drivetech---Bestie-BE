if params[:type] == "report"
  json.message 'Support Query created'
  json.data @support
  json.support_conversation @support.support_conversation
  json.support_messages @support.support_conversation.support_messages
  json.message_image @message.image.attached? ? @message.image.blob.url : ''
  json.support_image @support.image.attached? ? @support.image.blob.url : ''
elsif params[:type] == "block"
  json.message "User has been blocked"
  json.data @block_user
end