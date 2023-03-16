require "rails_helper"

RSpec.describe User, type: :model do
  describe "#latest_referral" do
    subject { user.latest_referral }

    let!(:expected_referral) { create(:referral, user:, created_at: 1.hour.from_now) }
    let(:user) { create(:user) }

    before do
      freeze_time
      create(:referral, user:, created_at: Time.current)
      create(:referral, user:, created_at: 1.hour.ago)
    end

    after { travel_back }

    it { is_expected.to eq(expected_referral) }
  end

  describe "#after_failed_otp_authentication" do
    subject(:after_failed_otp_authentication) { user.after_failed_otp_authentication }

    let(:user) { create(:user, secret_key: "some_key", otp_guesses: 3) }

    before { after_failed_otp_authentication }

    it "clears the secret key" do
      expect(user.secret_key).to be_nil
    end

    it "resets the number of OTP guesses" do
      expect(user.otp_guesses).to eq 0
    end
  end

  describe "#after_successful_otp_authentication" do
    subject(:after_successful_otp_authentication) { user.after_successful_otp_authentication }

    let(:user) { create(:user, secret_key: "some_key", otp_guesses: 3) }

    before { after_successful_otp_authentication }

    it "clears the secret key" do
      expect(user.secret_key).to be_nil
    end

    it "resets the OTP guesses" do
      expect(user.otp_guesses).to eq 0
    end
  end

  describe "#create_otp" do
    let(:user) { create(:user, secret_key: nil, otp_created_at: nil) }

    before do
      allow(Devise::Otp).to receive(:generate_key).and_return("123456")
      user.create_otp
    end

    it "sets a key" do
      expect(user.secret_key).to eq "123456"
    end

    it "sets the created_at" do
      expect(user.otp_created_at).not_to be_blank
    end
  end
end
