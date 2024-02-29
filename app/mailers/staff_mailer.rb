class StaffMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  def feedback_notification(staff:)
    mailer_options = {
      to: staff.email,
      reply_to_id: MISCONDUCT_NOTIFY_REPLY_TO_ID,
      subject: "New feedback received"
    }

    view_mail_manage(mailer_options:)
  end
end
