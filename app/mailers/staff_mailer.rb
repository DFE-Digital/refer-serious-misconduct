class StaffMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  def feedback_notification
    mailer_options = {
      to: staff_to_receive_feedback_notification,
      reply_to_id: MISCONDUCT_NOTIFY_REPLY_TO_ID,
      subject: "New feedback received"
    }

    view_mail_manage(mailer_options:)
  end

  private

  def staff_to_receive_feedback_notification
    Staff.where(feedback_notification: true).pluck(:email)
  end

  def misconduct_notify_mailer_to
    ENV["GOVUK_NOTIFY_MISCONDUCT_TEACHER_EMAIL"] || "misconduct.teacher@education.gov.uk"
  end
end
