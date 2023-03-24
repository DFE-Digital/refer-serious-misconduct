class DraftReferralsReminderJob < ApplicationJob
  sidekiq_options queue: "low"

  def perform
    return unless send_reminder_email?

    Referral.stale_drafts_reminder.each do |referral|
      next unless referral.reminder_emails.recent.none?

      SendReminderEmailJob.perform_later(referral)
    end
  end

  private

  def send_reminder_email?
    FeatureFlags::FeatureFlag.active?(:send_reminder_email)
  end
end
