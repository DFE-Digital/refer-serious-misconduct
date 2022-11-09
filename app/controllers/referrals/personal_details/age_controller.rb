module Referrals
  module PersonalDetails
    class AgeController < Referrals::BaseController
      def edit
        @personal_details_age_form =
          AgeForm.new(
            referral: current_referral,
            age_known: current_referral.age_known
          )
      end

      def update
        @personal_details_age_form =
          AgeForm.new(age_params.merge(referral: current_referral))

        if @personal_details_age_form.save(date_of_birth_params)
          redirect_to referrals_edit_personal_details_trn_path(current_referral)
        else
          render :edit
        end
      end

      private

      def age_params
        params.require(:referrals_personal_details_age_form).permit(:age_known)
      end

      def date_of_birth_params
        params.require(:referrals_personal_details_age_form).permit(
          "date_of_birth(3i)",
          "date_of_birth(2i)",
          "date_of_birth(1i)"
        )
      end
    end
  end
end
