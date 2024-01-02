module Referrals
  module AllegationEvidence
    class UploadController < Referrals::BaseController
      include ReferralHelper

      def edit
        @form = UploadForm.new(
          referral: current_referral,
          changing:,
        )
      end

      def update
        @form = UploadForm.new(
          upload_params.merge(
            referral: current_referral,
            changing:,
          )
        )

        if @form.save
          redirect_to [
                        :edit,
                        current_referral.routing_scope,
                        current_referral,
                        :allegation_evidence_uploaded
                      ]
        else
          render :edit
        end
      end

      private

      def upload_params
        params.require(:referrals_allegation_evidence_upload_form).permit(evidence_uploads: [])
      end
    end
  end
end
