module PublicReferrals
  module Allegation
    class CheckAnswersController < Referrals::Allegation::CheckAnswersController
      def next_path
        edit_public_referral_path(current_referral)
      end
    end
  end
end
