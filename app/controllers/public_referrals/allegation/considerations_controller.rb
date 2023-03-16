# frozen_string_literal: true

module PublicReferrals
  module Allegation
    class ConsiderationsController < Referrals::BaseController
      def edit
        @allegation_considerations_form =
          Referrals::Allegation::ConsiderationsForm.new(
            referral: current_referral,
            allegation_consideration_details: current_referral.allegation_consideration_details
          )
      end

      def update
        @allegation_considerations_form =
          Referrals::Allegation::ConsiderationsForm.new(
            allegation_considerations_params.merge(referral: current_referral)
          )

        if @allegation_considerations_form.save
          redirect_to next_page
        else
          render :edit
        end
      end

      private

      def allegation_considerations_params
        params.require(:referrals_allegation_considerations_form).permit(:allegation_consideration_details)
      end

      def next_path
        edit_public_referral_allegation_check_answers_path(current_referral)
      end
    end
  end
end
