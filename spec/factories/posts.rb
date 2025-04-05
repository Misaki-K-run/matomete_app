FactoryBot.define do
  factory :post do
    memo { Faker::String.random(length: 20) }
    sum { Faker::Number.binary(digits: 5) }
    association :user
  end
end
