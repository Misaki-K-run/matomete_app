FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    password { Faker::Internet.password(min_length: 8) }

    # テストが全て終わった後に Faker のユニーク値をクリア
    after(:all) do
      Faker::Internet.unique.clear
    end
  end
end
