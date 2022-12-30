module PublicReferrals
  module PersonalDetails
    class CheckAnswersController < Referrals::PersonalDetails::CheckAnswersController
      def update_path
        public_referral_personal_details_check_answers_path(current_referral)
      end

      def back_link
        session[:return_to] ||
          edit_public_referral_personal_details_name_path(current_referral)
      end
    end
  end
end
