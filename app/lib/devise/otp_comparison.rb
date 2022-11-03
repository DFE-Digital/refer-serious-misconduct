# frozen_string_literal: true

class Devise::OtpComparison
  def self.success?(resource, submitted_otp)
    submitted_otp == derive_otp(resource.secret_key)
  end

  def self.derive_otp(key)
    otp_generator = ROTP::HOTP.new(key)
    otp_generator.at(0)
  end
end
