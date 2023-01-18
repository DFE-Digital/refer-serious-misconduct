FactoryBot.define do
  factory :previous_allegation do
    referral

    trait :incomplete do
      completed_at { nil }
    end
  end
end
