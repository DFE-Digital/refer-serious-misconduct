FactoryBot.define do
  factory :referral do
    user
    eligibility_check

    trait :complete do
      allegation_details_complete { true }
      contact_details_complete { true }
      evidence_details_complete { true }
      personal_details_complete { true }
      teacher_role_complete { true }
      previous_misconduct_completed_at { Time.current }

      after(:create) do |referral|
        create(:organisation, :complete, referral:)
        create(:referrer, :complete, referral:)
      end
    end
  end
end
