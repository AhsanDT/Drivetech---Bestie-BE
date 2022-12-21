json.data do
  json.(@conversations)  do |conversation|
    json.conversation conversation
    json.sender_profile_image conversation.sender.profile_image.attached? ? conversation.sender.profile_image.blob.url : ''
    json.sender conversation.sender
    json.recepient_profile_image conversation.recepient.profile_image.attached? ? conversation.recepient.profile_image.blob.url : ''
    json.recepient conversation.recepient
    json.messages conversation.messages.last
  end
end
