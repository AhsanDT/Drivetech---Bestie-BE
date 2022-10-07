class User < ApplicationRecord

  has_secure_password

  validates :email, uniqueness: true, on: :create
  validates :password_digest, presence: true
  validates :password_digest, length: { minimum: 6 }, confirmation: true
  validates_presence_of :profile_type, inclusion: {in: :profile_type}

  has_one_attached :profile_image, dependent: :destroy
  has_one_attached :id_front_image, dependent: :destroy
  has_one_attached :id_back_image, dependent: :destroy
  has_one_attached :selfie, dependent: :destroy
  has_many_attached :portfolio, dependent: :destroy

  has_many :user_interests, dependent: :destroy
  has_many :interests, through: :user_interests
  has_one :camera_detail, dependent: :destroy

  accepts_nested_attributes_for :camera_detail, allow_destroy: true
  accepts_nested_attributes_for :user_interests, allow_destroy: true

  enum profile_type: {
    user: 0,
    bestie: 1
  }

  enum pronoun: {
    "he/him" => 0,
    "she/her" => 1,
    "they/them" => 2
  }

end
