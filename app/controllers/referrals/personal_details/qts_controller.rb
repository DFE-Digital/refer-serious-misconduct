module Referrals
  module PersonalDetails
    class QtsController < ReferralsController
      def edit
        @personal_details_qts_form =
          QtsForm.new(referral:, has_qts: referral.has_qts)
      end

      def update
        @personal_details_qts_form = QtsForm.new(qts_params.merge(referral:))

        if @personal_details_qts_form.save
          # TODO: Redirect to personal details summary
        else
          render :edit
        end
      end

      private

      def qts_params
        params.fetch(:referrals_personal_details_qts_form, {}).permit(:has_qts)
      end
    end
  end
end
