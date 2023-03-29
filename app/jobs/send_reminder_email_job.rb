class SendReminderEmailJob < ApplicationJob
  sidekiq_options queue: "low"

  def perform(referral)
    Referral.transaction do
      record_reminder(referral)
      send_reminder_email(referral)
    end
  end

  private

  def send_reminder_email(referral)
    UserMailer.draft_referral_reminder(referral).deliver_now
  end

  def record_reminder(referral)
    referral.reminder_emails.create!
  end
end
