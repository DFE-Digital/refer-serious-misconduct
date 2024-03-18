FactoryBot.define do
  factory :eligibility_check do
    reporting_as { "employer" }

    trait :complete do
      is_teacher { "yes" }
      teaching_in_england { "yes" }
      serious_misconduct { "yes" }
    end

    trait :serious_misconduct do
      serious_misconduct { "yes" }
    end

    trait :continue_with_referral do
      continue_with { "referral" }
    end

    trait :public do
      reporting_as { "public" }
    end
  end
end
