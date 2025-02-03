class Menu < ApplicationRecord
  validates :monday, length: { maximum: 2000 }
  validates :tuesday, length: { maximum: 2000 }
  validates :wednesday, length: { maximum: 2000 }
  validates :thursday, length: { maximum: 2000 }
  validates :friday, length: { maximum: 2000 }
  validates :saturday, length: { maximum: 2000 }
  validates :sunday, length: { maximum: 2000 }

  # 関連付け userいる？
  belongs_to :post
end
