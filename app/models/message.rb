class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation
  has_one_attached :image

  after_create_commit { MessageBroadcastJob.perform_later(self) }
end
