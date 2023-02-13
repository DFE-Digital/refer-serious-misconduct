FactoryBot.define do
  factory :staff do
    email { "test@example.org" }
    password { "Example123!" }
  end

  trait :confirmed do
    confirmed_at { Time.zone.now }
  end

  trait :can_view_support do
    view_support { true }
  end

  trait :can_manage_referrals do
    manage_referrals { true }
  end
end
