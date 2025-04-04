class Post < ApplicationRecord
  validates :memo, length: { maximum: 1000 }
  validates :sum, numericality: { only_integer: true, less_than_or_equal_to: 100000 }

  # 関連付け
  belongs_to :user
  has_one :menu, dependent: :destroy
  has_many :shopping_lists, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  accepts_nested_attributes_for :shopping_lists, allow_destroy: true

  # ransack
  def self.ransackable_attributes(auth_object = nil)
    [ "user" ]
  end

  def self.ransackable_associations(auth_object = nil)
    [ "menu", "shopping_lists", "user" ]
  end
end
