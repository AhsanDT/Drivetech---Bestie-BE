class NotificationWorker
  include Sidekiq::Worker
  # sidekiq_options queue: default

  def perform(*args, user, body, send_by_id, send_by_name, notification_type)
    Notification.create(subject: "Booking", body: body , user_id: user, send_by_id: send_by_id, send_by_name: send_by_name, notification_type: notification_type)
  end
end