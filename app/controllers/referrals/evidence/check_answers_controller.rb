module Referrals
  module Evidence
    class CheckAnswersController < Referrals::BaseController
      def edit
        @evidence_check_answers_form =
          CheckAnswersForm.new(
            evidence_details_complete:
              current_referral.evidence_details_complete
          )
      end

      def update
        @evidence_check_answers_form =
          CheckAnswersForm.new(
            check_answers_params.merge(referral: current_referral)
          )

        if @evidence_check_answers_form.save
          redirect_to edit_referral_path(current_referral)
        else
          render :edit
        end
      end

      def delete
      end

      def destroy
        filename = evidence.filename
        evidence.document.purge
        evidence.destroy

        redirect_path =
          if current_referral.evidences.any?
            edit_referral_evidence_uploaded_path(current_referral)
          else
            edit_referral_evidence_upload_path(current_referral)
          end

        redirect_to(redirect_path, flash: { success: "#{filename} deleted" })
      end

      def evidence
        @evidence ||= current_referral.evidences.find(params[:evidence_id])
      end
      helper_method :evidence

      private

      def check_answers_params
        params.fetch(:referrals_evidence_check_answers_form, {}).permit(
          :evidence_details_complete
        )
      end
    end
  end
end
