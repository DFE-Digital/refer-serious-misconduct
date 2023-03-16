FactoryBot.define do
  factory :referral_evidence do
    referral
    document { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/upload1.pdf"), "application/pdf") }
  end
end
