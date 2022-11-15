module Referrals
  module Allegation
    class ConfirmController < Referrals::BaseController
      def edit
        @allegation_confirm_form = ConfirmForm.new(referral: current_referral)
      end

      def update
        @allegation_confirm_form =
          ConfirmForm.new(confirm_params.merge(referral: current_referral))

        if @allegation_confirm_form.save
          redirect_to edit_referral_path(current_referral)
        else
          render :edit
        end
      end

      private

      def confirm_params
        params.fetch(:referrals_allegation_confirm_form, {}).permit(
          :allegation_details_complete
        )
      end
    end
  end
end
