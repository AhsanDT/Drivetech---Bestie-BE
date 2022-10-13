class UserSupportMessage < SupportMessage
  belongs_to :support_conversation
  belongs_to :user ,class_name: "User", foreign_key: :sender_id
  has_one_attached :image
end
