class Conversation < ApplicationRecord
  belongs_to :recepient, class_name: 'User', foreign_key: :recipient_id
  belongs_to :sender, class_name: 'User', foreign_key: :sender_id
  has_many :messages
end
