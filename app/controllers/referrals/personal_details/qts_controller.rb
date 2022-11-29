module Referrals
  module PersonalDetails
    class QtsController < Referrals::BaseController
      def edit
        @personal_details_qts_form =
          QtsForm.new(
            referral: current_referral,
            has_qts: current_referral.has_qts
          )
      end

      def update
        @personal_details_qts_form =
          QtsForm.new(qts_params.merge(referral: current_referral))

        if @personal_details_qts_form.save
          redirect_to next_page
        else
          render :edit
        end
      end

      private

      def qts_params
        params.fetch(:referrals_personal_details_qts_form, {}).permit(:has_qts)
      end

      def next_path
        referrals_edit_personal_details_confirm_path(current_referral)
      end
    end
  end
end
