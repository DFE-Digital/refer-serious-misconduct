FactoryBot.define do
  factory :referrer do
    referral { nil }
    name { "MyString" }

    trait :incomplete do
      name { nil }
    end

    trait :complete do
      completed_at { Time.current }
    end
  end
end
