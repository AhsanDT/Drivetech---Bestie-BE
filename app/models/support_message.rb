class SupportMessage < ApplicationRecord
  belongs_to :support_conversation
  has_one_attached :image
end
