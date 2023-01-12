module Referrals
  module Allegation
    class DetailsController < Referrals::BaseController
      def edit
        @allegation_details_form =
          DetailsForm.new(
            allegation_details: current_referral.allegation_details,
            allegation_format: current_referral.allegation_format,
            allegation_upload: current_referral.allegation_upload
          )
      end

      def update
        @allegation_details_form =
          DetailsForm.new(
            allegation_details_params.merge(referral: current_referral)
          )

        if @allegation_details_form.save
          redirect_to next_page
        else
          render :edit
        end
      end

      private

      def allegation_details_params
        params.require(:referrals_allegation_details_form).permit(
          :allegation_format,
          :allegation_details,
          :allegation_upload
        )
      end

      def next_path
        edit_referral_allegation_dbs_path(current_referral)
      end

      def back_link
        edit_referral_path(current_referral)
      end
      helper_method :back_link

      def update_path
        referral_allegation_details_path(current_referral)
      end
      helper_method :update_path
    end
  end
end
