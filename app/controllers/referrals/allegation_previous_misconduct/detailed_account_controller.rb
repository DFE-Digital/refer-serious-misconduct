module Referrals
  module AllegationPreviousMisconduct
    class DetailedAccountController < Referrals::BaseController
      def edit
        @detailed_account_form =
          DetailedAccountForm.new(
            previous_misconduct_format: current_referral.previous_misconduct_format,
            previous_misconduct_details: current_referral.previous_misconduct_details,
            previous_misconduct_upload: current_referral.previous_misconduct_upload
          )
      end

      def update
        @detailed_account_form =
          DetailedAccountForm.new(detailed_account_form_params.merge(referral: current_referral))
        if @detailed_account_form.save
          redirect_to @detailed_account_form.next_path
        else
          render :edit
        end
      end

      private

      def detailed_account_form_params
        params.require(:referrals_allegation_previous_misconduct_detailed_account_form).permit(
          :previous_misconduct_format,
          :previous_misconduct_details,
          :previous_misconduct_upload
        )
      end
    end
  end
end
