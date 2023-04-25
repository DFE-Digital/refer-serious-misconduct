module PublicReferrals
  module Referrer
    class NameController < Referrals::Referrer::NameController
      private

      def previous_path
        public_referral_personal_details_path(current_referral)
      end
    end
  end
end
