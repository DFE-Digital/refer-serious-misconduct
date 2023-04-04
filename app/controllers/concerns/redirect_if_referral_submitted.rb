# frozen_string_literal: true
module RedirectIfReferralSubmitted
  extend ActiveSupport::Concern

  included do
    before_action { redirect_if_referral_submitted(current_referral) if current_referral }
  end

  def redirect_if_referral_submitted(referral)
    return unless referral.submitted? && controller_name != "confirmation"

    redirect_to(users_referral_path(referral))
  end
end
