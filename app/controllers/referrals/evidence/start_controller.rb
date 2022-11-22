module Referrals
  module Evidence
    class StartController < Referrals::BaseController
      def edit
        @evidence_start_form =
          StartForm.new(
            referral: current_referral,
            has_evidence: current_referral.has_evidence
          )
      end

      def update
        @evidence_start_form =
          StartForm.new(start_params.merge(referral: current_referral))

        if @evidence_start_form.save
          if @evidence_start_form.has_evidence
            redirect_to referrals_edit_evidence_upload_path(current_referral)
          else
            current_referral.update(evidences: [])
            redirect_to referrals_edit_evidence_confirm_path(current_referral)
          end
        else
          render :edit
        end
      end

      private

      def start_params
        params.fetch(:referrals_evidence_start_form, {}).permit(:has_evidence)
      end
    end
  end
end
