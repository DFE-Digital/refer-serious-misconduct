FactoryBot.define do
  factory :feedback do
    satisfaction_rating { "very_satisfied" }
    improvement_suggestion { "feedback goes here" }
    contact_permission_given { [true, false].sample }
    email { "#{SecureRandom.hex(5)}@example.com" }
  end
end
