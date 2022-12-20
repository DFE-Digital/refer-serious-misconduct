class User < ApplicationRecord
  devise :validatable, :trackable
  include Devise::Models::OtpAuthenticatable

  has_many :referrals
  has_one :latest_referral,
          -> { order(created_at: :desc) },
          class_name: "Referral"

  scope :newest_first, -> { order(created_at: :desc) }

  after_commit :reload_uuid, on: :create

  def reload_uuid
    self[:uuid] = self.class.where(id:).pick(:uuid)
  end

  def after_failed_otp_authentication
    clear_otp_state
  end

  def after_successful_otp_authentication
    clear_otp_state
  end

  def clear_otp_state
    update(secret_key: nil, otp_guesses: 0)
  end

  def create_otp
    secret_key = Devise::Otp.generate_key
    update(secret_key:, otp_created_at: Time.zone.now)
  end

  def create_referral!(eligibility_check_id:)
    eligibility_check = EligibilityCheck.find_by!(id: eligibility_check_id)
    referrals.create!(eligibility_check_id: eligibility_check.id)
  end
end
