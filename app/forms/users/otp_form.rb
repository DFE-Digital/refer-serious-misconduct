class Users::OtpForm
  MAX_GUESSES = 5
  EXPIRY_IN_MINUTES = 30.minutes

  include ActiveModel::Model

  attr_accessor :otp, :id
  attr_writer :email

  validates :otp,
            presence: true,
            length: {
              minimum: 6,
              maximum: 6,
              allow_blank: true,
            }
  validate :must_be_expected_otp

  def must_be_expected_otp
    return unless user.secret_key

    expected_otp = Devise::Otp.derive_otp(user.secret_key)

    if otp != expected_otp
      errors.add(:otp, "Enter a correct security code")
      user.increment!(:otp_guesses)
    end
  end

  def otp_expired?
    return false unless user.last_otp_created_at

    (EXPIRY_IN_MINUTES.ago >= user.last_otp_created_at)
  end

  def maximum_guesses?
    user.otp_guesses >= MAX_GUESSES
  end

  def user
    @user ||= User.find(id)
  end

  def email
    @email ||= user.email
  end
end
