module Referrals
  module Evidence
    class UploadedController < Referrals::BaseController
      def edit
        case params[:more_evidence]
        when "yes"
          redirect_to edit_referral_evidence_upload_path(current_referral)
        when "no"
          redirect_to edit_referral_evidence_check_answers_path(
                        current_referral
                      )
        else
          render :edit
        end
      end
    end
  end
end
