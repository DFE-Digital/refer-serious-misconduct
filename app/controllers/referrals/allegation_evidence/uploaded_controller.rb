module Referrals
  module AllegationEvidence
    class UploadedController < Referrals::BaseController
      include ReferralHelper

      def edit
        @form = UploadedForm.new(referral: current_referral)
      end

      def update
        @form = UploadedForm.new(more_evidence_params.merge(referral: current_referral))

        if @form.valid?(:update)
          subsection =
            (
              if @form.more_evidence?
                :allegation_evidence_upload
              else
                :allegation_evidence_check_answers
              end
            )

          redirect_to([:edit, current_referral.routing_scope, current_referral, subsection])
        else
          render :edit
        end
      end

      def more_evidence_params
        params.fetch(:referrals_allegation_evidence_uploaded_form, {}).permit(:more_evidence)
      end
    end
  end
end
