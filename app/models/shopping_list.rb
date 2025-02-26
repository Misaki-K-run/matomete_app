class ShoppingList < ApplicationRecord
  validates :category, inclusion: { in: %w[meat_fish vegetable other] }
  validates :name, length: { maximum: 100 }

  belongs_to :post
end
