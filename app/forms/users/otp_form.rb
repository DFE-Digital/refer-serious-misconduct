class Users::OtpForm
  include ActiveModel::Model

  attr_accessor :otp, :id
  attr_writer :email

  validates :otp, length: { minimum: 6, maximum: 6, allow_blank: true }
  validate :expected_otp_submitted

  def expected_otp_submitted
    expected_otp = Devise::Otp.derive_otp(user.secret_key)
    errors.add(:otp, "Enter a correct security code") unless otp == expected_otp
  end

  def user
    @user ||= User.find(id)
  end

  def email
    @email ||= user.email
  end
end
