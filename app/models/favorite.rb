class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :ai_generate

  validates :user_id, uniqueness: { scope: :ai_generate_id }
end
