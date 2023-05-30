# frozen_string_literal: true

module PublicReferrals
  module AllegationDetails
    class ConsiderationsController < Referrals::BaseController
      def edit
        @form =
          Referrals::AllegationDetails::ConsiderationsForm.new(
            referral: current_referral,
            allegation_consideration_details: current_referral.allegation_consideration_details
          )
      end

      def update
        @form =
          Referrals::AllegationDetails::ConsiderationsForm.new(
            allegation_considerations_params.merge(referral: current_referral)
          )

        if @form.save
          redirect_to @form.next_path
        else
          render :edit
        end
      end

      private

      def allegation_considerations_params
        params.require(:referrals_allegation_details_considerations_form).permit(
          :allegation_consideration_details
        )
      end
    end
  end
end
