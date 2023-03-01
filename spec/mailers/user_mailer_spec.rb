require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe ".otp" do
    subject(:email) { described_class.otp(user) }

    let(:secret_key) { Devise::Otp.generate_key }
    let(:user) { build(:user, secret_key:) }
    let(:otp) { Devise::Otp.derive_otp(secret_key) }

    it "sends a one-time password to the user" do
      expect(email.to).to include user.email
    end

    it "includes the one-time password in the email body" do
      expect(email.body).to include(otp)
    end

    it "sets the subject" do
      expect(email.subject).to eq "#{otp} is your confirmation code"
    end
  end

  describe ".referral_link" do
    subject(:email) { described_class.referral_link(referral) }

    let(:user) { create(:user) }
    let(:referral) { create(:referral, user_id: user.id) }

    it "sends a referral link to the user" do
      expect(email.to).to include user.email
    end

    it "includes the referral link in the email body" do
      expect(email.body).to include(edit_referral_url(referral))
    end

    it "sets the subject" do
      expect(
        email.subject
      ).to eq "Your referral of serious misconduct by a teacher"
    end
  end
end
