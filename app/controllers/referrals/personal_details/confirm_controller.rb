module Referrals
  module PersonalDetails
    class ConfirmController < ReferralsController
      def edit
        @personal_details_confirm_form = ConfirmForm.new(referral:)
      end

      def update
        @personal_details_confirm_form =
          ConfirmForm.new(confirm_params.merge(referral:))

        if @personal_details_confirm_form.save
          redirect_to edit_referral_path(referral)
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
