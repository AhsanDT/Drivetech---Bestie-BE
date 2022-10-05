class Page < ApplicationRecord
  has_rich_text :content
  validates :permalink,  uniqueness: true
end
