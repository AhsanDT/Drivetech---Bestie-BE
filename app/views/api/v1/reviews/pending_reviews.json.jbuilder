json.pending_reviews @bookings.each do |booking|
  json.booking booking
  json.send_to_name booking.send_to.full_name
  json.send_to_profile_image booking.send_to.profile_image.attached? ? booking.send_to.profile_image.blob.url : ''
end