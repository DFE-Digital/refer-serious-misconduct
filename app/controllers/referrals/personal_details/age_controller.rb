module Referrals
  module PersonalDetails
    class AgeController < ReferralsController
      def edit
        @personal_details_age_form = AgeForm.new(referral:)
      end

      def update
        @personal_details_age_form = AgeForm.new(referral:)

        if @personal_details_age_form.save(date_of_birth_params)
          redirect_to referrals_edit_personal_details_trn_path(referral)
        else
          render :edit
        end
      end

      private

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
