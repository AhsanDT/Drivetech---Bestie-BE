class User < ApplicationRecord
  require 'csv'
  has_secure_password
  # include PgSearch::Model
  #     pg_search_scope :custom_search,
  #                 against: [:email, :first_name, :last_name],
  #                 using: {
  #                   trigram: {
  #                     threshold: 0.01,
  #                     word_similarity: true
  #                   }
  #                 }

    acts_as_mappable :default_formula => :sphere,
                    :distance_field_name => :distance,
                    :lat_column_name => :latitude,
                    :lng_column_name => :longitude
  validates :email, uniqueness: true, on: :create
  validates :phone_number, uniqueness: true, on: :create, if: :phone_number?
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
  has_many :user_talents, dependent: :destroy
  has_many :talents, through: :user_talents
  has_many :notifications, dependent: :destroy
  has_many :mobile_devices, dependent: :destroy
  has_many :social_media, dependent: :destroy
  has_many :conversations, dependent: :destroy, foreign_key: :sender_id
  has_many :conversations, dependent: :destroy, foreign_key: :recipient_id
  has_many :messages
  has_many :banks, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  has_one :schedule, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :job_posts, dependent: :destroy
  has_many :block_users, dependent: :destroy
  has_many :blocked_users, :foreign_key => "blocked_by_id", :class_name => "BlockUser"
  has_many :recent_users, dependent: :destroy
  has_many :recent_users, :foreign_key => "user_id", :class_name => "RecentUser"
  has_many :bookings, dependent: :destroy
  has_many :bookings, :foreign_key => "send_by_id", :class_name => "Booking"
  has_many :reviews, dependent: :destroy
  has_many :reviews, :foreign_key => "review_to_id", :class_name => "Review"

  accepts_nested_attributes_for :camera_detail, allow_destroy: true, :reject_if => :which_profile_type
  accepts_nested_attributes_for :user_interests, allow_destroy: true
  accepts_nested_attributes_for :user_talents, allow_destroy: true, :reject_if => :which_profile_type
  accepts_nested_attributes_for :social_media, allow_destroy: true, :reject_if => :which_profile_type


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

  scope :ordered_by_age, -> { reorder(age: :asc) }
  scope :ordered_by_sex, -> { reorder(sex: :asc) }
  scope :ordered_by_country, -> { reorder(country: :asc) }

  self.per_page = 10

  def full_name
    first_name + ' ' + last_name
  end

  def which_profile_type
    profile_type == 'user'
  end

  def self.to_csv
    attributes = %w{full_name email phone_number country location age sex rate experience}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.find_each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end

end
