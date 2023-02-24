# frozen_string_literal: true
class ApplicationMailer < Mail::Notify::Mailer
  GENERIC_NOTIFY_TEMPLATE = "04b96c89-77ec-4c07-af01-3c96a4b8b5d7"

  MISCONDUCT_GENERIC_NOTIFY_TEMPLATE = "4f8e7de9-3987-4e75-974f-ac94068c4a62"
  MISCONDUCT_NOTIFY_REPLY_TO_ID = "83cac27e-b914-46a3-a1f9-56e5acb07d05"

  private

  def set_action_mailer_misconduct_key
    ActionMailer::Base.notify_settings[:api_key] = ENV.fetch(
      "GOVUK_NOTIFY_MANAGE_SERIOUS_MISCONDUCT_API_KEY"
    )
  end

  def set_action_mailer_default_key
    ActionMailer::Base.notify_settings[:api_key] = ENV.fetch(
      "GOVUK_NOTIFY_API_KEY"
    )
  end

  def deliver_as_manage_misconduct
    set_action_mailer_misconduct_key
    yield
  ensure
    set_action_mailer_default_key
  end
end
