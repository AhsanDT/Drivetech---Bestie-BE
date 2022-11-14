json.data do
  json.(@conversations)  do |conversation|
    json.conversation conversation
    json.messages conversation.messages
  end
end
