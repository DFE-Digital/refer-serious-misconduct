FactoryBot.define do
  factory :referral do
    user

    trait :complete do
      allegation_details_complete { true }
      contact_details_complete { true }
      evidence_details_complete { true }
      personal_details_complete { true }
      teacher_role_complete { true }
      previous_misconduct_completed_at { Time.current }
    end
  end
end
