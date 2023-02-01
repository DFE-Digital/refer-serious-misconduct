class UserMailer < ApplicationMailer
  def send_otp(user)
    @otp = Devise::Otp.derive_otp(user.secret_key)
    Rails.logger.info "OTP: #{@otp}" if Rails.env.development?
    mailer_options = { to: user.email, subject: "Confirm your email address" }

    notify_email(mailer_options)
  end
end
