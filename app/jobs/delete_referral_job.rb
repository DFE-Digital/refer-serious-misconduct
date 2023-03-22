class DeleteReferralJob < ApplicationJob
  sidekiq_options queue: "low"

  def perform(referral_id)
    Referral.find(referral_id).destroy
  end
end
