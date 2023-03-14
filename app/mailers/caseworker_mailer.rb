class CaseworkerMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  def referral_submitted(referral)
    @name = referral.name
    @link = manage_interface_referral_url(referral)
    mailer_options = {
      to: misconduct_notify_mailer_to,
      reply_to_id: MISCONDUCT_NOTIFY_REPLY_TO_ID,
      subject: "#{@name} has been referred"
    }

    view_mail_manage(mailer_options:)
  end

  private

  def misconduct_notify_mailer_to
    ENV["GOVUK_NOTIFY_MISCONDUCT_TEACHER_EMAIL"] ||
      "misconduct.teacher@education.gov.uk"
  end
end
