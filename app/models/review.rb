class Review < ApplicationRecord
  has_many_attached :images, dependent: :destroy
  belongs_to :review_by, :class_name=>'User'
  belongs_to :review_to, :class_name=>'User'
  belongs_to :booking
end