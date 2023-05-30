module Referrals
  module AllegationDetails
    class DetailsController < Referrals::BaseController
      def edit
        @form =
          DetailsForm.new(
            referral: current_referral,
            allegation_details: current_referral.allegation_details,
            allegation_format: current_referral.allegation_format,
            allegation_upload_file: current_referral.allegation_upload_file
          )
      end

      def update
        @form = DetailsForm.new(allegation_details_params.merge(referral: current_referral))

        if @form.save
          redirect_to @form.next_path
        else
          render :edit
        end
      end

      private

      def allegation_details_params
        params.require(:referrals_allegation_details_details_form).permit(
          :allegation_format,
          :allegation_details,
          :allegation_upload_file
        )
      end
    end
  end
end
