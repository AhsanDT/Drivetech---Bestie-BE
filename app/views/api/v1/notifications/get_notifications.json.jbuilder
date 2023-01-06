json.notification @notifications.each do |notification|
  json.notification notification
  json.send_by_profile_image notification.send_by.profile_image.attached? ? notification.send_by.profile_image.blob.url : ''
end