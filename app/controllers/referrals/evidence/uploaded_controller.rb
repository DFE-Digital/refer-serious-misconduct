module Referrals
  module Evidence
    class UploadedController < Referrals::BaseController
      include ReferralHelper

      def edit
        @uploaded_form = UploadedForm.new(referral: current_referral)
      end

      def update
        @uploaded_form = UploadedForm.new(more_evidence_params.merge(referral: current_referral))

        if @uploaded_form.valid?
          subsection = (@uploaded_form.more_evidence? ? :evidence_upload : :evidence_check_answers)

          redirect_to([:edit, current_referral.routing_scope, current_referral, subsection])
        else
          render :edit
        end
      end

      def more_evidence_params
        params.fetch(:referrals_evidence_uploaded_form, {}).permit(:more_evidence)
      end
    end
  end
end
