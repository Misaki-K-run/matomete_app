class ShoppingList < ApplicationRecord
  validates :category, inclusion: { in: %w[meat_fish vegetable other] }
  validates :name, length: { maximum: 2000 }

  belongs_to :post
end
