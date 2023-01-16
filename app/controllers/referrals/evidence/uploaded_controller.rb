module Referrals
  module Evidence
    class UploadedController < Referrals::BaseController
      include ReferralHelper

      def edit
        @uploaded_form = UploadedForm.new
      end

      def update
        @uploaded_form = UploadedForm.new(more_evidence_params)

        if @uploaded_form.valid?
          subsection =
            if @uploaded_form.more_evidence?
              :evidence_upload
            else
              :evidence_check_answers
            end

          redirect_to(
            [
              :edit,
              current_referral.routing_scope,
              current_referral,
              subsection
            ]
          )
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
