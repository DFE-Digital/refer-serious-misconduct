module Referrals
  module PersonalDetails
    class ConfirmController < Referrals::BaseController
      def edit
        @personal_details_confirm_form =
          ConfirmForm.new(referral: current_referral)
      end

      def update
        @personal_details_confirm_form =
          ConfirmForm.new(confirm_params.merge(referral: current_referral))

        if @personal_details_confirm_form.save
          redirect_to edit_referral_path(current_referral)
        else
          render :edit
        end
      end

      private

      def confirm_params
        params.fetch(:referrals_personal_details_confirm_form, {}).permit(
          :personal_details_complete
        )
      end
    end
  end
end
