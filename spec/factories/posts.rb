FactoryBot.define do
  factory :post do
    memo { Faker::String.random(length: 20) }
    sum { Faker::Number.number(digits: 5) }
    association :user

    trait :with_menu do
      after(:create) do |post|
        create(:menu, post: post)
      end
    end
  end
end
