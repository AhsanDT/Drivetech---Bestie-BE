class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :support_conversations, dependent: :destroy,foreign_key: :recipient_id
  has_many :admin_support_messages, dependent: :destroy,foreign_key: :sender_id

  enum status: {
    active: 0,
    inactive: 1
  }

  def full_name
    first_name + ' ' + last_name
  end
end
