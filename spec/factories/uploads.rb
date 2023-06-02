FactoryBot.define do
  factory :upload do
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
  end
end
