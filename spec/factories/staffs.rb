FactoryBot.define do
  factory :staff do
    email { "test@example.org" }
    password { "Example123!" }

    can_view_support
  end

  trait :confirmed do
    confirmed_at { Time.zone.now }
  end

  trait :deleted do
    deleted_at { Time.zone.now }
  end

  trait :can_view_support do
    view_support { true }
  end

  trait :can_manage_referrals do
    manage_referrals { true }
  end

  trait :developer do
    developer { true }
  end

  trait :random do
    email { "#{SecureRandom.hex(5)}@example.com" }
    password { "Example123!" }
  end
end
