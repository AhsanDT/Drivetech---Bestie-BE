class Message < ApplicationRecord
  belongs_to :user
  belongs_to :conversation
  has_one_attached :image
end
