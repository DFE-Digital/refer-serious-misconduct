module Referrals
  class PreviousMisconductDetailedAccountController < BaseController
    def edit
      @detailed_account_form =
        PreviousMisconductDetailedAccountForm.new(referral: current_referral)
    end

    def update
      @detailed_account_form =
        PreviousMisconductDetailedAccountForm.new(
          previous_misconduct_detailed_account_form_params.merge(
            referral: current_referral
          )
        )
      if @detailed_account_form.save
        redirect_to referral_previous_misconduct_path(current_referral)
      else
        render :edit
      end
    end

    private

    def previous_misconduct_detailed_account_form_params
      params.require(:previous_misconduct_detailed_account_form).permit(
        :details,
        :format,
        :upload
      )
    end
  end
end
