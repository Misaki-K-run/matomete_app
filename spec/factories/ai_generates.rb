FactoryBot.define do
  factory :ai_generate do
    budget_request { 10000 }
    people_request { 4 }
    menu_response { { monday: 'Pasta', tuesday: 'Pizza' }.to_json } # 必要に応じて値を変更
    shopping_list_response { { meat: 'Chicken', vegetable: 'Carrot' }.to_json } # 必要に応じて値を変更
    sum_response { 20000 }
    association :user
  end
end
