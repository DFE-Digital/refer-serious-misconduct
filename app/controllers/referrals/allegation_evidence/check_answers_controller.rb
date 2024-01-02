module Referrals
  module AllegationEvidence
    class CheckAnswersController < Referrals::BaseController
      include ReferralHelper

      def edit
        @form =
          CheckAnswersForm.new(
            referral: current_referral,
            evidence_details_complete: current_referral.evidence_details_complete
          )
      end

      def update
        @form = CheckAnswersForm.new(
          check_answers_params.merge(referral: current_referral)
        )

        if @form.save
          redirect_to @form.next_path
        else
          render :edit
        end
      end

      def delete
        @form = CheckAnswersForm.new(
          changing:,
          referral: current_referral
        )
      end

      def destroy
        @form = CheckAnswersForm.new(
          changing:,
          referral: current_referral
        )
        filename = evidence.filename
        evidence.destroy

        subsection =
          (
            if current_referral.evidence_uploads.any?
              :allegation_evidence_uploaded
            else
              :allegation_evidence_upload
            end
          )
        redirect_path = [:edit, current_referral.routing_scope, current_referral, subsection]
        redirect_to(redirect_path, flash: { success: "#{filename} deleted" })
      end

      def evidence
        @evidence ||= current_referral.evidence_uploads.find(params[:allegation_evidence_id])
      end
      helper_method :evidence

      private

      def check_answers_params
        params.fetch(:referrals_allegation_evidence_check_answers_form, {}).permit(
          :evidence_details_complete
        )
      end
    end
  end
end
