FactoryBot.define do
  factory :referral_evidence do
    referral
    categories_other { "conduct_behaviour_attitude" }
    document do
      Rack::Test::UploadedFile.new(
        Rails.root.join("spec/fixtures/files/upload1.pdf"),
        "application/pdf"
      )
    end
  end
end
