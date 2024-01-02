module Referrals
  module AllegationPreviousMisconduct
    class DetailedAccountController < Referrals::BaseController
      def edit
        @form =
          DetailedAccountForm.new(
            referral: current_referral,
            changing:,
            previous_misconduct_format: current_referral.previous_misconduct_format,
            previous_misconduct_details: current_referral.previous_misconduct_details,
            previous_misconduct_upload_file: current_referral.previous_misconduct_upload_file
          )
      end

      def update
        @form =
          DetailedAccountForm.new(
            detailed_account_form_params.merge(
              referral: current_referral,
              changing:,
            )
          )
        if @form.save
          redirect_to @form.next_path
        else
          render :edit
        end
      end

      private

      def detailed_account_form_params
        params.require(:referrals_allegation_previous_misconduct_detailed_account_form).permit(
          :previous_misconduct_format,
          :previous_misconduct_details,
          :previous_misconduct_upload_file
        )
      end
    end
  end
end
