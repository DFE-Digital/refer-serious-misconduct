class User < ApplicationRecord
  devise :validatable, :trackable
  include Devise::Models::OtpAuthenticatable

  has_many :referrals

  def latest_referral
    referrals.order(created_at: :desc).first
  end
end
