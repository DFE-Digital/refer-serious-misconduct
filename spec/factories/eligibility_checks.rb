FactoryBot.define do
  factory :eligibility_check do
    reporting_as { "employer" }

    trait :complete do
      is_teacher { "yes" }
      teaching_in_england { "yes" }
      serious_misconduct { "yes" }
    end

    trait :not_unsupervised do
      is_teacher { "no" }
      unsupervised_teaching { "no" }
    end
  end
end
