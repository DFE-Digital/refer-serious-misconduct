FactoryBot.define do
  factory :organisation do
    referral

    trait :complete do
      name { "Example School" }
      complete { true }
      street_1 { "1 Example Street" }
      city { "Example City" }
      postcode { "AB1 2CD" }
    end
  end
end
