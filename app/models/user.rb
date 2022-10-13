class User < ApplicationRecord
  require 'csv'
  has_secure_password
  include PgSearch::Model
     pg_search_scope :custom_search,
                  against: [:first_name, :last_name, :email, :phone_number]
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
  has_many :supports, dependent: :destroy
  has_many :support_conversations, dependent: :destroy,foreign_key: :sender_id
  has_many :user_support_messages, dependent: :destroy,foreign_key: :sender_id
  has_many :cards, dependent: :destroy

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

  scope :count_male_user, -> { where('sex = (?)','male').count }
  scope :count_female_user, -> { where('sex = (?)','female').count }
  scope :end_users, -> {where('profile_type = (?)', '0')}
  scope :bestie_users, -> {where('profile_type = (?)', '1')}
  self.per_page = 10

  def full_name
    first_name + ' ' + last_name
  end

  def self.to_csv
    attributes = %w{full_name email phone_number country location age sex}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.find_each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end

end
