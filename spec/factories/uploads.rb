FactoryBot.define do
  factory :upload do
    attachment { Rack::Test::UploadedFile.new("spec/fixtures/files/upload1.pdf") }

    trait :allegation do
      association :uploadable, factory: :referral
      uploadable_type { "Referral" }
      section { "allegation" }
    end
  end
end
