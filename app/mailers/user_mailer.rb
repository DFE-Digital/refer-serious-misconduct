class UserMailer < ApplicationMailer
  def otp(user)
    @otp = Devise::Otp.derive_otp(user.secret_key)
    Rails.logger.info "OTP: #{@otp}" if Rails.env.development?
    mailer_options = { to: user.email, subject: "Confirm your email address" }

    view_mail(GENERIC_NOTIFY_TEMPLATE, mailer_options)
  end

  def referral_link(referral)
    @referral = referral
    @user = referral.user
    mailer_options = {
      to: @user.email,
      subject: "Your referral of serious misconduct by a teacher"
    }

    view_mail(GENERIC_NOTIFY_TEMPLATE, mailer_options)
  end
end
