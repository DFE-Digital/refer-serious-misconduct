module Referrals
  module Evidence
    class CheckAnswersController < Referrals::BaseController
      def edit
        @evidence_check_answers_form =
          CheckAnswersForm.new(referral: current_referral)
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

        redirect_to(
          referrals_edit_evidence_check_answers_path(current_referral),
          flash: {
            success: "#{filename} deleted"
          }
        )
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
