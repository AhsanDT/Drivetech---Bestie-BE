def fcm_push_notification
  require 'fcm'
  def self.push_notification(notification)
    fcm_client = FCM.new(ENV['FIREBASE_SECRET_KEY']) # set your FCM_SERVER_KEY
    options = { priority: 'high',
                # data: { message: message, icon: image },
                notification: {
                  title: notification.subject,
                  body: notification.body,
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
