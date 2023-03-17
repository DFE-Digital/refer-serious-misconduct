class DeviseMailer < Devise::Mailer
  GOVUK_NOTIFY_TEMPLATE_ID = ENV.fetch("GOVUK_NOTIFY_TEMPLATE_ID_DEVISE", "3441548d-bd6b-46b5-b986-8860f824cae8")

  def devise_mail(record, action, opts = {}, &_block)
    initialize_from_record(record)
    ApplicationMailer.set_action_mailer_refer_key
    view_mail(GOVUK_NOTIFY_TEMPLATE_ID, headers_for(action, opts))
  end
end
