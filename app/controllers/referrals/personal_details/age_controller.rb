module Referrals
  module PersonalDetails
    class AgeController < Referrals::BaseController
      def edit
        @personal_details_age_form =
          AgeForm.new(
            age_known: current_referral.age_known,
            date_of_birth: current_referral.date_of_birth
          )
      end

      def update
        @personal_details_age_form =
          AgeForm.new(
            age_params.merge(
              date_params: date_of_birth_params,
              referral: current_referral
            )
          )

        if @personal_details_age_form.save
          redirect_to next_page
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
          "date_of_birth(1i)",
          "date_of_birth(2i)",
          "date_of_birth(3i)"
        )
      end

      def next_path
        edit_referral_personal_details_trn_path(current_referral)
      end
    end
  end
end
