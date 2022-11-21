# frozen_string_literal: true

require "rails_helper"

RSpec.describe Users::OtpForm do
  describe "#otp_expired?" do
    it "is true if user otp is expired" do
      Timecop.freeze do
        user =
          create(
            :user,
            last_otp_created_at: Users::OtpForm::EXPIRY_IN_MINUTES.ago,
          )
        form = described_class.new(id: user.id)

        expect(form.otp_expired?).to eq true
      end
    end

    it "is false is user otp is not yet expired" do
      unexpired_time = Users::OtpForm::EXPIRY_IN_MINUTES.ago + 1.minute
      Timecop.freeze do
        user = create(:user, last_otp_created_at: unexpired_time)
        form = described_class.new(id: user.id)

        expect(form.otp_expired?).to eq false
      end
    end

    it "is false if no last_otp_created_at is set" do
      Timecop.freeze do
        user = create(:user, last_otp_created_at: nil)
        form = described_class.new(id: user.id)

        expect(form.otp_expired?).to eq false
      end
    end
  end
end
