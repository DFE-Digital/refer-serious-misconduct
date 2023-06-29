FactoryBot.define do
  factory :upload do
    association :uploadable, factory: :referral

    file { Rack::Test::UploadedFile.new("spec/fixtures/files/upload1.pdf") }

    trait :allegation do
      association :uploadable, factory: :referral
      uploadable_type { "Referral" }
      section { "allegation" }
    end

    trait :duties do
      association :uploadable, factory: :referral
      uploadable_type { "Referral" }
      section { "duties" }
    end

    trait :evidence do
      association :uploadable, factory: :referral
      uploadable_type { "Referral" }
      section { "evidence" }
    end

    trait :suspect do
      malware_scan_result { "suspect" }
    end

    trait :pending do
      malware_scan_result { "pending" }
    end
  end
end
