class Booking < ApplicationRecord
  belongs_to :send_by, :class_name=>'User'
  belongs_to :send_to, :class_name=>'User'

  enum status: {
    "Accepted": 0,
    "Rejected": 1
  }

  after_create_commit { BookingBroadcastJob.perform_later(self) }
end