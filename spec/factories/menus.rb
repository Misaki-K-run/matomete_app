FactoryBot.define do
  factory :menu do
    monday { Faker::Food.dish }
    tuesday { Faker::Food.dish }
    wednesday { Faker::Food.dish }
    thursday { Faker::Food.dish }
    friday { Faker::Food.dish }
    saturday { Faker::Food.dish }
    sunday { Faker::Food.dish }
    association :post
  end
end
