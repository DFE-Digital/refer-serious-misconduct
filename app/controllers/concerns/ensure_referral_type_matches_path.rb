# frozen_string_literal: true
module EnsureReferralTypeMatchesPath
  extend ActiveSupport::Concern

  class ReferralTypeDoesNotMatchPath < StandardError
  end

  def check_referral_against_path(referral)
    if referral.from_employer? && !controller_path.match?(/^referrals/)
      raise ReferralTypeDoesNotMatchPath,
            "Referral id #{referral.id} is not an employer referral"
    end

    if referral.from_member_of_public? &&
         !controller_path.match?(/^public_referrals/)
      raise ReferralTypeDoesNotMatchPath,
            "Referral id #{referral.id} is not a public referral"
    end
  end
end
