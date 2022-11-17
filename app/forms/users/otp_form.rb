class Users::OtpForm
  MAX_GUESSES = 5
  include ActiveModel::Model

  attr_accessor :otp, :id
  attr_writer :email

  validates :otp, length: { minimum: 6, maximum: 6, allow_blank: true }
  validate :expected_otp_submitted

  def expected_otp_submitted
    expected_otp = Devise::Otp.derive_otp(user.secret_key)

    if otp != expected_otp
      errors.add(:otp, "Enter a correct security code")
      user.increment!(:otp_guesses)
    end
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
