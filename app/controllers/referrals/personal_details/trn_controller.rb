module Referrals
  module PersonalDetails
    class TrnController < ReferralsController
      def edit
        @personal_details_trn_form =
          TrnForm.new(
            referral:,
            trn: referral.trn,
            trn_known: referral.trn_known
          )
      end

      def update
        @personal_details_trn_form = TrnForm.new(trn_params.merge(referral:))

        if @personal_details_trn_form.save
          # TODO: Redirect to personal details confirm
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
    end
  end
end
