FactoryBot.define do
  factory :referrer do
    referral { nil }

    trait :incomplete do
      name { nil }
    end

    trait :complete do
      completed_at { Time.current }
      job_title { "Headteacher" }
      name { "Jane Smith" }
      phone { "01234567890" }
    end
  end
end
