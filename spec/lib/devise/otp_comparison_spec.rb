require "rails_helper"

RSpec.describe Devise::OtpComparison do
  describe ".success?" do
    it "returns true if the OTPs match" do
      secret_key = ROTP::Base32.random
      resource = double(secret_key:)
      submitted_otp = ROTP::HOTP.new(secret_key).at(0)

      expect(described_class.success?(resource, submitted_otp)).to eq true
    end

    it "returns false if the OTPs don't match" do
      secret_key = ROTP::Base32.random
      resource = double(secret_key:)
      submitted_otp = 'bad_guess'

      expect(described_class.success?(resource, submitted_otp)).to eq false

    end
  end
end
