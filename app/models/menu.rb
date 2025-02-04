class Menu < ApplicationRecord
  validates :monday, length: { maximum: 2000 }
  validates :tuesday, length: { maximum: 2000 }
  validates :wednesday, length: { maximum: 2000 }
  validates :thursday, length: { maximum: 2000 }
  validates :friday, length: { maximum: 2000 }
  validates :saturday, length: { maximum: 2000 }
  validates :sunday, length: { maximum: 2000 }

  belongs_to :post
end
