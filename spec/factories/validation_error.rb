# frozen_string_literal: true

FactoryBot.define do
  factory :validation_error do
    form_object { "Referrals::ReferrerNameForm" }
    details do
      {
        "last_name" => {
          "value" => "",
          "messages" => ["Enter your last name"]
        },
        "first_name" => {
          "value" => "",
          "messages" => ["Enter your first name"]
        }
      }
    end
  end
end
