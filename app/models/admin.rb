class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  require 'csv'
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include PgSearch::Model
     pg_search_scope :custom_search,
                  against: [:first_name, :last_name, :email, :phone_number, :username]

  has_many :support_conversations, dependent: :destroy,foreign_key: :recipient_id
  has_many :admin_support_messages, dependent: :destroy,foreign_key: :sender_id

  enum status: {
    active: 0,
    inactive: 1
  }

  scope :ordered_by_country, -> { reorder(location: :asc) }

  self.per_page = 10

  def full_name
    first_name + ' ' + last_name
  end

  def self.to_csv
    attributes = %w{full_name email username phone_number location status}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.find_each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end
end
