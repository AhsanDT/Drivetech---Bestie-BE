class SupportConversation < ApplicationRecord
  belongs_to :support
  has_many :admin_support_messages, dependent: :destroy
  has_many :user_support_messages, dependent: :destroy
  belongs_to :sender, class_name: "User", foreign_key: :sender_id
  belongs_to :recipient, class_name: "Admin", foreign_key: :recipient_id
  has_many :support_messages, dependent: :destroy
end
