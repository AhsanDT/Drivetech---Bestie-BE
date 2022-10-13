class Support < ApplicationRecord
  has_one_attached :image
  belongs_to :user
  has_one :support_conversation

  enum status: {
    pending: 0,
    in_progress: 1,
    completed: 2
  }
end
