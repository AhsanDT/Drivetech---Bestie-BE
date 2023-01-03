class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :send_by, :class_name=>'User'

  after_create :call_notification_service

  def call_notification_service
    FcmNotificationsService.push_notification(self)
  end
end
