class AiGenerate < ApplicationRecord
  validates :budget_request, presence: true
  validates :people_request, presence: true
  validates :menu_response, presence: true
  validates :shopping_list_response, presence: true
  validates :sum_response, presence: true
  validates :special_request, length: { maximum: 100 }
  belongs_to :user

end
