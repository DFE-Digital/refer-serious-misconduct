class UserMailer < ApplicationMailer
  def otp(user)
    @otp = Devise::Otp.derive_otp(user.secret_key)
    Rails.logger.info "OTP: #{@otp} for email #{user.email}" if Rails.env.development?
    mailer_options = { to: user.email, subject: "#{@otp} is your confirmation code" }

    view_mail_refer(mailer_options:)
  end

  def referral_link(referral)
    @referral = referral
    @user = referral.user
    mailer_options = {
      to: @user.email,
      subject: "Your referral of serious misconduct by a teacher"
    }

    view_mail_refer(mailer_options:)
  end

  def referral_submitted(referral)
    @link = users_referral_url(referral)
    @user = referral.user
    mailer_options = {
      to: @user.email,
      subject: "Your referral of serious misconduct has been sent"
    }

    view_mail_refer(mailer_options:)
  end

  def draft_referral_reminder(referral)
    @link = polymorphic_url([:edit, referral.routing_scope, referral])
    @user = referral.user
    mailer_options = { to: @user.email, subject: "Your referral will be deleted in 7 days" }

    view_mail_refer(mailer_options:)
  end
end
