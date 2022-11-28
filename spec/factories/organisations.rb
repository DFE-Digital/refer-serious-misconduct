FactoryBot.define do
  factory :organisation do
    referral

    trait :complete do
      completed_at { Time.current }
    end
  end
end
