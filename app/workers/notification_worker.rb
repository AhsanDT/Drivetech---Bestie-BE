class NotificationWorker
  include Sidekiq::Worker
  # sidekiq_options queue: default

  def perform(*args, send_to_id, current_user, hour)
    send_to = User.find_by(id: send_to_id).full_name
    Notification.create(subject: "Booking", body: "#{hour} hour before your Appointment with #{send_to}", user_id: current_user)
  end
end