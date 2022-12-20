# frozen_string_literal: true
module ReferralPaths
  extend ActiveSupport::Concern

  def edit_path_for(referral)
    if referral.from_member_of_public?
      edit_public_referral_path(referral)
    else
      edit_referral_path(referral)
    end
  end
end
