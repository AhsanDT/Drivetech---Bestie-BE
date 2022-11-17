class Package < ApplicationRecord
  has_many :subscriptions, dependent: :destroy
end