FactoryBot.define do
  factory :user, aliases: [:owner] do
    first_name { "Taro" }
    last_name { "Yamada" }
    sequence(:email) { |n| "test#{n}@example.com" }
    password { "pass1234" }
  end
end
