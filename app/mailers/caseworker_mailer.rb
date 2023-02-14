class CaseworkerMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  before_action :set_action_mailer_misconduct_key

  def referral_submitted(referral)
    @name = referral.referrer_name
    @link = manage_interface_referral_url(referral)
    mailer_options = {
      to: misconduct_notify_mailer_to,
      reply_to_id: MISCONDUCT_NOTIFY_REPLY_TO_ID,
      subject: "#{@name} has been referred"
    }

    view_mail(MISCONDUCT_GENERIC_NOTIFY_TEMPLATE, mailer_options)
  end

  private

  def misconduct_notify_mailer_to
    ENV["GOVUK_NOTIFY_MISCONDUCT_TEACHER_EMAIL"] ||
      "misconduct.teacher@education.gov.uk"
  end
end
