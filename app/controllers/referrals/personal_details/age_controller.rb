module Referrals
  module PersonalDetails
    class AgeController < Referrals::BaseController
      def edit
        @personal_details_age_form = AgeForm.new(referral: current_referral)
      end

      def update
        @personal_details_age_form =
          AgeForm.new(approximate_age_params.merge(referral: current_referral))

        if @personal_details_age_form.save(date_of_birth_params)
          redirect_to referrals_edit_personal_details_trn_path(current_referral)
        else
          render :edit
        end
      end

      private

      def approximate_age_params
        params.require(:referrals_personal_details_age_form).permit(
          :age_known,
          :approximate_age
        )
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
