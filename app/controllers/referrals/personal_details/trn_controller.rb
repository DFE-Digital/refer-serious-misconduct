module Referrals
  module PersonalDetails
    class TrnController < Referrals::BaseController
      def edit
        @personal_details_trn_form =
          TrnForm.new(
            referral: current_referral,
            trn: current_referral.trn,
            trn_known: current_referral.trn_known
          )
      end

      def update
        @personal_details_trn_form =
          TrnForm.new(trn_params.merge(referral: current_referral))

        if @personal_details_trn_form.save
          redirect_to next_page
        else
          render :edit
        end
      end

      private

      def trn_params
        params.require(:referrals_personal_details_trn_form).permit(
          :trn_known,
          :trn
        )
      end

      def next_path
        referrals_edit_personal_details_qts_path(current_referral)
      end
    end
  end
end
