class DeleteDraftReferralsJob < ApplicationJob
  sidekiq_options queue: "low"

  def perform
    Referral.stale_drafts.each { |referral| DeleteReferralJob.perform_later(referral.id) }
  end
end
