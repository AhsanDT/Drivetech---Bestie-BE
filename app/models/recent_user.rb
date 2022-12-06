class RecentUser < ApplicationRecord
  belongs_to :user, :class_name=>'User'
  belongs_to :recent_user, :class_name=>'User'
end
