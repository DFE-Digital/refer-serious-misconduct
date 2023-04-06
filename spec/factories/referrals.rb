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
      previous_misconduct_complete { true }

      after(:create) do |referral|
        create(:organisation, :complete, referral:)
        create(:referrer, :complete, referral:)
      end
    end

    trait :public do
      eligibility_check factory: %i[eligibility_check public complete]
    end

    trait :employer do
      eligibility_check factory: %i[eligibility_check complete]
    end

    trait :employer_complete do
      eligibility_check factory: %i[eligibility_check complete]
      submitted
      personal_details_employer
      contact_details_employer
      teacher_role_employer
      allegation_details
      previous_misconduct_employer
      evidence
    end

    trait :public_complete do
      eligibility_check factory: %i[eligibility_check public complete]
      submitted
      personal_details_public
      teacher_role_public
      allegation_details
      evidence
    end

    trait :submitted do
      complete
      submitted_at { Time.current }
    end

    trait :with_attachments do
      allegation_format { "upload" }
      duties_format { "upload" }

      allegation_upload { Rack::Test::UploadedFile.new("spec/fixtures/files/upload1.pdf") }
      duties_upload { Rack::Test::UploadedFile.new("spec/fixtures/files/upload2.pdf") }
    end

    trait :with_pdf do
      pdf { Rack::Test::UploadedFile.new("spec/fixtures/files/upload1.pdf") }
    end

    trait :personal_details_public do
      first_name { "John" }
      last_name { "Smith" }
      personal_details_complete { true }
    end

    trait :personal_details_employer do
      date_of_birth { 30.years.ago }
      first_name { "John" }
      has_qts { "yes" }
      last_name { "Smith" }
      personal_details_complete { true }
      trn { "1234567" }
    end

    trait :contact_details_employer do
      address_known { true }
      address_line_1 { "1 Example Street" }
      contact_details_complete { true }
      email_address { "test@example.com" }
      email_known { true }
      phone_known { true }
      phone_number { "01234567890" }
      postcode { "AB1 2CD" }
      town_or_city { "Example Town" }
    end

    trait :teacher_role_employer do
      duties_details { "Teaching children in year 2" }
      duties_format { "details" }
      employment_status { "left_role" }
      job_title { "Teacher" }
      reason_leaving_role { "dismissed" }
      role_end_date { Time.zone.local(2023, 3, 10) }
      role_end_date_known { true }
      role_start_date { Time.zone.local(2022, 4, 10) }
      role_start_date_known { true }
      same_organisation { true }
      teacher_role_complete { true }
      work_address_line_1 { "2 Different Street" }
      work_address_line_2 { "Same Road" }
      work_location_known { true }
      work_organisation_name { "Different School" }
      work_postcode { "AB1 2CD" }
      work_town_or_city { "Example Town" }
      working_somewhere_else { "yes" }
    end

    trait :teacher_role_public do
      duties_details { "Teaching children in year 2" }
      duties_format { "details" }
      job_title { "Teacher" }
      organisation_address_known { true }
      organisation_address_line_1 { "1 Example Street" }
      organisation_address_line_2 { "Different Road" }
      organisation_name { "Example School" }
      organisation_postcode { "AB1 2CD" }
      organisation_town_or_city { "Example Town" }
      teacher_role_complete { true }
    end

    trait :allegation_details do
      allegation_details_complete { true }
      allegation_format { "details" }
      allegation_details { "They were rude to a child" }
      dbs_notified { true }
    end

    trait :previous_misconduct_employer do
      previous_misconduct_complete { true }
      previous_misconduct_reported { "true" }
      previous_misconduct_format { "details" }
      previous_misconduct_details { "They were rude to a child" }
    end

    trait :previous_misconduct_employer_upload do
      previous_misconduct_complete { true }
      previous_misconduct_reported { "true" }
      previous_misconduct_format { "upload" }
      previous_misconduct_upload do
        Rack::Test::UploadedFile.new(
          Rails.root.join("spec/fixtures/files/upload1.pdf"),
          "application/pdf"
        )
      end
    end

    trait :evidence do
      evidence_details_complete { true }
      has_evidence { true }

      after(:create) { |referral| create(:referral_evidence, referral:) }
    end
  end
end
