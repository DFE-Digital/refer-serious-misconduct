module Referrals
  module Allegation
    class DetailsController < Referrals::BaseController
      def edit
        @allegation_details_form = DetailsForm.new(referral: current_referral)
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
        referrals_edit_allegation_dbs_path(current_referral)
      end
    end
  end
end
