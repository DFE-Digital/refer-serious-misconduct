require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe ".send_otp" do
    subject(:email) { described_class.send_otp(user) }

    let(:secret_key) { Devise::Otp.generate_key }
    let(:user) { build(:user, secret_key:) }

    it "sends a one-time password to the user" do
      expect(email.to).to include user.email
    end

    it "includes the one-time password in the email body" do
      expected_otp = Devise::Otp.derive_otp(secret_key)
      expect(email.body).to include(expected_otp)
    end

    it "sets the subject" do
      expect(email.subject).to eq "Confirm your email address"
    end
  end
end
