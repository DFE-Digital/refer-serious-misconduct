class DeviseMailer < Devise::Mailer
  GOVUK_NOTIFY_TEMPLATE_ID =
    ENV.fetch(
      "GOVUK_NOTIFY_TEMPLATE_ID_DEVISE",
      "f1a31a19-a161-45b9-8450-1f0e10daeaf3"
    )

  def devise_mail(record, action, opts = {}, &_block)
    initialize_from_record(record)
    view_mail(GOVUK_NOTIFY_TEMPLATE_ID, headers_for(action, opts))
  end
end
