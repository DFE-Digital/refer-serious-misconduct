module Referrals
  module Evidence
    class CheckAnswersController < Referrals::BaseController
      include ReferralHelper

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
          redirect_to(
            subsection_path(referral: current_referral, action: :edit)
          )
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
            subsection_path(
              referral: current_referral,
              action: :edit,
              subsection: :evidence_uploaded
            )
          else
            subsection_path(
              referral: current_referral,
              action: :edit,
              subsection: :evidence_upload
            )
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
