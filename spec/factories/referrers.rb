FactoryBot.define do
  factory :referrer do
    referral { nil }
    name { "MyString" }

    trait :incomplete do
      name { nil }
    end
  end
end
