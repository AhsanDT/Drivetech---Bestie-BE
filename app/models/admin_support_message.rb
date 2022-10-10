class AdminSupportMessage < SupportMessage
  belongs_to :support_conversation
  belongs_to :sender, class_name: 'Admin', foreign_key: 'sender_id'
  has_one_attached :image
end
