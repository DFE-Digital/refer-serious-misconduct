FactoryBot.define do
  factory :user do
    email { "#{SecureRandom.hex(5)}@example.com" }
  end
end
