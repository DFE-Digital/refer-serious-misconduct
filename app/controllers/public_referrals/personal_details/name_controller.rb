module PublicReferrals
  module PersonalDetails
    class NameController < Referrals::PersonalDetails::NameController
      def next_path
        edit_public_referrals_personal_details_check_answers_path(
          current_referral
        )
      end

      def update_path
        public_referrals_personal_details_name_path(current_referral)
      end
    end
  end
end
