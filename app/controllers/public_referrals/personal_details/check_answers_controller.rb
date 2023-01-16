module PublicReferrals
  module PersonalDetails
    class CheckAnswersController < Referrals::PersonalDetails::CheckAnswersController
      def next_path
        edit_public_referral_path(current_referral)
      end

      def update_path
        public_referral_personal_details_check_answers_path(current_referral)
      end
    end
  end
end
