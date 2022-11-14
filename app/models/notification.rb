class Notification < ApplicationRecord
  belongs_to :user

  after_create :call_notification_service

  def call_notification_service
    FcmNotificationsService.push_notification(self)
  end
end
