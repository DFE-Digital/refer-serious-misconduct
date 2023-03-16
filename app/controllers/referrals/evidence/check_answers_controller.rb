module Referrals
  module Evidence
    class CheckAnswersController < Referrals::BaseController
      include ReferralHelper

      def edit
        @evidence_check_answers_form =
          CheckAnswersForm.new(evidence_details_complete: current_referral.evidence_details_complete)
      end

      def update
        @evidence_check_answers_form = CheckAnswersForm.new(check_answers_params.merge(referral: current_referral))

        if @evidence_check_answers_form.save
          redirect_to([:edit, current_referral.routing_scope, current_referral])
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

        subsection =
          (
            if current_referral.evidences.any?
              :evidence_uploaded
            else
              :evidence_upload
            end
          )
        redirect_path = [:edit, current_referral.routing_scope, current_referral, subsection]
        redirect_to(redirect_path, flash: { success: "#{filename} deleted" })
      end

      def evidence
        @evidence ||= current_referral.evidences.find(params[:evidence_id])
      end
      helper_method :evidence

      private

      def check_answers_params
        params.fetch(:referrals_evidence_check_answers_form, {}).permit(:evidence_details_complete)
      end
    end
  end
end
