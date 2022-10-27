class Conversation < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: :recipient_id
  belongs_to :user, class_name: 'User', foreign_key: :sender_id
  has_many :messages
end
