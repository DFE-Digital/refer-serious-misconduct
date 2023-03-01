class Users::OtpForm
  MAX_GUESSES = 5
  EXPIRY_TIME = 1.hour

  include ActiveModel::Model

  attr_accessor :otp, :uuid
  attr_writer :email

  validates :otp,
            presence: true,
            length: {
              minimum: 6,
              maximum: 6,
              allow_blank: true
            }
  validate :must_be_expected_otp

  def must_be_expected_otp
    return unless secret_key?

    expected_otp = Devise::Otp.derive_otp(user.secret_key)

    if otp != expected_otp
      errors.add(:otp, "Enter a correct security code")
      user.increment!(:otp_guesses)
    end
  end

  def otp_expired?
    user.otp_created_at.blank? || (EXPIRY_TIME.ago >= user.otp_created_at)
  end

  def secret_key?
    user.secret_key.present?
  end

  def maximum_guesses?
    user.otp_guesses >= MAX_GUESSES
  end

  def user
    @user ||= User.find_by!(uuid:)
  end

  def email
    @email ||= user.email
  end
end
