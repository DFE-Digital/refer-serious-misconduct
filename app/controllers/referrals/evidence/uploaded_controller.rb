module Referrals
  module Evidence
    class UploadedController < Referrals::BaseController
      def edit
        @uploaded_form = UploadedForm.new
      end

      def update
        @uploaded_form = UploadedForm.new(more_evidence_params)

        if @uploaded_form.valid?
          if @uploaded_form.more_evidence?
            redirect_to edit_referral_evidence_upload_path(current_referral)
          else
            redirect_to edit_referral_evidence_check_answers_path(
                          current_referral
                        )
          end
        else
          render :edit
        end
      end

      def more_evidence_params
        params.fetch(:referrals_evidence_uploaded_form, {}).permit(
          :more_evidence
        )
      end
    end
  end
end
