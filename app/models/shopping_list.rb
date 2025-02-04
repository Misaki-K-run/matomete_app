class ShoppingList < ApplicationRecord
  validates :meat_fish, length: { maximum: 2000 }
  validates :vegetable, length: { maximum: 2000 }
  validates :other, length: { maximum: 2000 }

  belongs_to :post
end
