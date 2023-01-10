json.notification @notifications.each do |notification|
  json.notification notification
  json.send_by_profile_image notification.send_by.profile_image.attached? ? notification.send_by.profile_image.blob.url : ''
  json.conversation Conversation.where(sender_id: notification.send_by_id, recipient_id: notification.user_id).or(Conversation.where(sender_id: notification.user_id, recipient_id: notification.send_by_id))
end