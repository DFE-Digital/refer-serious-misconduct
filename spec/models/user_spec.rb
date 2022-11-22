require "rails_helper"

RSpec.describe User, type: :model do
  describe "#latest_referral" do
    it "returns the most recently created referral" do
      user = create(:user)
      expected_referral =
        create(:referral, user:, created_at: Time.zone.now + 1.hour)
      create(:referral, user:, created_at: Time.zone.now)
      create(:referral, user:, created_at: Time.zone.now - 1.hour)

      expect(user.latest_referral).to eq expected_referral
    end
  end

  describe "#after_failed_otp_authentication" do
    it "clears OTP-related fields" do
      user = create(:user, secret_key: "some_key", otp_guesses: 3)

      user.after_failed_otp_authentication

      expect(user.secret_key).to be_nil
      expect(user.otp_guesses).to eq 0
    end
  end

  describe "#after_successful_otp_authentication" do
    it "clears OTP-related fields" do
      user = create(:user, secret_key: "some_key", otp_guesses: 3)

      user.after_successful_otp_authentication

      expect(user.secret_key).to be_nil
      expect(user.otp_guesses).to eq 0
    end
  end

  describe "#create_otp" do
    it "sets a key and timestamp" do
      user = create(:user, secret_key: nil, last_otp_created_at: nil)
      allow(Devise::Otp).to receive(:generate_key).and_return("123456")

      user.create_otp

      expect(user.secret_key).to eq "123456"
      expect(user.last_otp_created_at).to_not be_blank
    end
  end
end
