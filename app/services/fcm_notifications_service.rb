class FcmNotificationsService
  require 'fcm'
  def self.push_notification(notification)
    data = {
      subject: notification.subject,
      body: notification.body,
      type: notification.notification_type,
      name: notification.send_by_name,
      send_by_id: notification.send_by_id,
      send_to_id: notification.user_id,
      booking_sender_id: notification.booking_sender_id,
      sender_profile_image: notification.send_by.profile_image.attached? ? notification.send_by.profile_image.blob.url : ''
    }
    fcm_client = FCM.new(ENV['FIREBASE_SECRET_KEY']) # set your FCM_SERVER_KEY
    options = { priority: 'high',
                data: data,
                notification: {
                  subject: notification.subject,
                  body: notification.body,
                  type: notification.notification_type,
                  name: notification.send_by_name,
                  send_by_id: notification.send_by_id,
                  send_to_id: notification.user_id
                }
              }
    registration_ids = User.find_by(id: notification.user_id).mobile_devices.pluck(:mobile_token)
    # A registration ID looks something like: “dAlDYuaPXes:APA91bFEipxfcckxglzRo8N1SmQHqC6g8SWFATWBN9orkwgvTM57kmlFOUYZAmZKb4XGGOOL9wqeYsZHvG7GEgAopVfVupk_gQ2X5Q4Dmf0Cn77nAT6AEJ5jiAQJgJ_LTpC1s64wYBvC”
    registration_ids.each do |registration_id|
      response = fcm_client.send(registration_id, options)
      puts response
    end
  end
end
