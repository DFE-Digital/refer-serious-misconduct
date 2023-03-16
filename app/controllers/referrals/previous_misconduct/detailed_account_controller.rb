module Referrals
  module PreviousMisconduct
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
        @detailed_account_form = DetailedAccountForm.new(detailed_account_form_params.merge(referral: current_referral))
        if @detailed_account_form.save
          redirect_to next_page
        else
          render :edit
        end
      end

      private

      def detailed_account_form_params
        params.require(:referrals_previous_misconduct_detailed_account_form).permit(
          :previous_misconduct_format,
          :previous_misconduct_details,
          :previous_misconduct_upload
        )
      end

      def next_path
        edit_referral_previous_misconduct_check_answers_path(current_referral)
      end
    end
  end
end
