FactoryBot.define do
  factory :referrer do
    referral { nil }

    trait :incomplete do
      first_name { nil }
      last_name { nil }
    end

    trait :complete do
      complete { true }
      job_title { "Headteacher" }
      first_name { "Jane" }
      last_name { "Smith" }
      phone { "01234567890" }
    end
  end
end
