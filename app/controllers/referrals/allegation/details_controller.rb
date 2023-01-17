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
        [
          :edit,
          current_referral.routing_scope,
          current_referral,
          :allegation,
          :dbs
        ]
      end
    end
  end
end
