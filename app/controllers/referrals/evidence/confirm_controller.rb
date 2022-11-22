module Referrals
  module Evidence
    class ConfirmController < Referrals::BaseController
      def edit
        @evidence_confirm_form = ConfirmForm.new(referral: current_referral)
      end

      def update
        @evidence_confirm_form =
          ConfirmForm.new(confirm_params.merge(referral: current_referral))

        if @evidence_confirm_form.save
          redirect_to edit_referral_path(current_referral)
        else
          render :edit
        end
      end

      def back_link
        if current_referral.evidences.any?
          referrals_edit_evidence_categories_path(current_referral, current_referral.evidences.last)
        else
          referrals_edit_evidence_start_path(current_referral)
        end
      end
      helper_method :back_link

      private

      def confirm_params
        params.fetch(:referrals_evidence_confirm_form, {}).permit(
          :evidence_details_complete
        )
      end
    end
  end
end
