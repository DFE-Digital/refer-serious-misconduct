require "rails_helper"

RSpec.describe Devise::Otp do
  describe ".valid?" do
    it "returns true if the OTPs match" do
      secret_key = ROTP::Base32.random
      submitted_otp = ROTP::HOTP.new(secret_key).at(0)

      expect(described_class.valid?(secret_key, submitted_otp)).to eq true
    end

    it "returns false if the OTPs don't match" do
      secret_key = ROTP::Base32.random
      submitted_otp = "bad_guess"

      expect(described_class.valid?(secret_key, submitted_otp)).to eq false
    end
  end
end
