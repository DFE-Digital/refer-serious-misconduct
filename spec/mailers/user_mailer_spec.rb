require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe ".send_otp" do
    it "sends a one-time password to the user" do
      secret_key = Devise::Otp.generate_key
      user = build(:user, secret_key:)
      email = described_class.send_otp(user)
      expected_otp = Devise::Otp.derive_otp(secret_key)

      expect(email.to).to include user.email
      expect(email.subject).to eq "Confirm your email address"
      expect(email.body).to include(expected_otp)
    end
  end
end
