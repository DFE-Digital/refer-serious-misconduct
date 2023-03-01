# frozen_string_literal: true

require "rails_helper"

RSpec.describe Users::OtpForm do
  let(:form) { described_class.new(uuid: user.uuid) }

  describe "#otp_expired?" do
    subject { form.otp_expired? }

    let(:user) { create(:user, otp_created_at:) }

    before { freeze_time }
    after { travel_back }

    context "when the OTP is 60 minutes old" do
      let(:otp_created_at) { 60.minutes.ago }

      it { is_expected.to be_truthy }
    end

    context "when the OTP is 59 minutes old" do
      let(:otp_created_at) { 59.minutes.ago }

      it { is_expected.to be_falsey }
    end

    context "when there is no OTP timestamp" do
      let(:otp_created_at) { nil }

      it { is_expected.to be_truthy }
    end
  end

  describe "#secret_key?" do
    subject { form.secret_key? }

    context "when user secret_key is present" do
      let(:user) { create(:user, secret_key: "test_key") }

      it { is_expected.to be_truthy }
    end

    context "when user secret_key is blank" do
      let(:user) { create(:user, secret_key: nil) }

      it { is_expected.to be_falsey }
    end
  end
end
