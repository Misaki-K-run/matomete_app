class Post < ApplicationRecord
  validates :memo, length: { maximum: 1000 }
  validates :sum, length: { maximum: 100000 }

  # 関連付け
  belongs_to :user
  has_one :menu, dependent: :destroy
  has_many :shopping_lists, dependent: :destroy
  accepts_nested_attributes_for :shopping_lists, allow_destroy: true
end
