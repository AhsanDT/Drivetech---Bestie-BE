class NotificationWorker
  include Sidekiq::Worker
  # sidekiq_options queue: default

  def perform(*args, user, body)
    Notification.create(subject: "Booking", body: body , user_id: user)
  end
end