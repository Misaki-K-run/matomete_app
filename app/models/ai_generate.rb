class AiGenerate < ApplicationRecord
  validates :budget_request, presence: true
  validates :people_request, presence: true

  belongs_to :user
end
