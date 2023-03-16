module PublicReferrals
  module PersonalDetails
    class NameController < Referrals::PersonalDetails::NameController
      def next_path
        [:edit, current_referral.routing_scope, current_referral, :personal_details, :check_answers]
      end
    end
  end
end
