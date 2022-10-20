# frozen_string_literal: true
class ApplicationMailer < Mail::Notify::Mailer
  GENERIC_NOTIFY_TEMPLATE = "04b96c89-77ec-4c07-af01-3c96a4b8b5d7"

  def notify_email(headers)
    headers =
      headers.merge(rails_mailer: mailer_name, rails_mail_template: action_name)
    view_mail(GENERIC_NOTIFY_TEMPLATE, headers)
  end
end
