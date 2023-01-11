json.bookings @bookings.each do |booking|
  json.booking booking
  json.send_by_id booking.send_by_id
  json.send_by_name booking.send_by.full_name
  json.send_by_profile_image booking.send_by.profile_image.attached? ? booking.send_by.profile_image.blob.url : ''
  json.send_to_id booking.send_to_id
  json.send_to_name booking.send_to.full_name
  json.send_to_profile_image booking.send_to.profile_image.attached? ? booking.send_to.profile_image.blob.url : ''
  json.conversation Conversation.where(sender_id: booking.send_by_id, recipient_id: booking.send_to_id).or(Conversation.where(sender_id: booking.send_to_id, recipient_id: booking.send_by_id))
end