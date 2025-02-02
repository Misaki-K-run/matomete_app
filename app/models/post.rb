class Post < ApplicationRecord
  validates :memo, length: { maximum: 1000 }
  validates :sum, length: { maximum: 100000 }

  belongs_to :user
end
