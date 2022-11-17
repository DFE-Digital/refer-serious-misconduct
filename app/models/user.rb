class User < ApplicationRecord
  devise :validatable, :trackable
  include Devise::Models::OtpAuthenticatable

  has_many :referrals

  def latest_referral
    referrals.order(created_at: :desc).first
  end

  def after_failed_otp_authentication
    clear_otp_state
  end

  def after_successful_otp_authentication
    clear_otp_state
  end

  def clear_otp_state
    update(secret_key: nil, otp_guesses: nil)
  end
end
