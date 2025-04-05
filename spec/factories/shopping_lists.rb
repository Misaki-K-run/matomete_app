FactoryBot.define do
  factory :shopping_list do
    name { Faker::Food.vegetables }
    category { "vegetable" }
    association :post
  end
end
