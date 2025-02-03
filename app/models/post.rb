class Post < ApplicationRecord
  validates :memo, length: { maximum: 1000 }
  validates :sum, length: { maximum: 100000 }

  # 関連付け
  belongs_to :user
end
