module Referrals
  module Evidence
    class UploadController < Referrals::BaseController
      include ReferralHelper

      def edit
        @evidence_upload_form = UploadForm.new(referral: current_referral)
      end

      def update
        @evidence_upload_form =
          UploadForm.new(upload_params.merge(referral: current_referral))

        if @evidence_upload_form.save
          redirect_to(
            subsection_path(
              referral: current_referral,
              action: :edit,
              subsection: :evidence_uploaded
            )
          )
        else
          render :edit
        end
      end

      private

      def upload_params
        params.require(:referrals_evidence_upload_form).permit(
          evidence_uploads: []
        )
      end
    end
  end
end
