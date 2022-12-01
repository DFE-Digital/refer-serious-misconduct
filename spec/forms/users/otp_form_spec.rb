# frozen_string_literal: true

require "rails_helper"

RSpec.describe Users::OtpForm do
  describe "#otp_expired?" do
    subject { form.otp_expired? }

    let(:form) { described_class.new(id: user.id) }
    let(:user) { create(:user, otp_created_at:) }

    before { freeze_time }
    after { travel_back }

    context "when the OTP is 30 minutes old" do
      let(:otp_created_at) { 30.minutes.ago }

      it { is_expected.to be_truthy }
    end

    context "when the OTP is 29 minutes old" do
      let(:otp_created_at) { 29.minutes.ago }

      it { is_expected.to be_falsey }
    end

    context "when there is no OTP timestamp" do
      let(:otp_created_at) { nil }

      it { is_expected.to be_truthy }
    end
  end
end
