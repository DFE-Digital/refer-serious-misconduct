module Referrals
  class PreviousMisconductReportedController < BaseController
    def edit
      @previous_misconduct_reported_form =
        PreviousMisconductReportedForm.new(referral: current_referral)
    end

    def update
      @previous_misconduct_reported_form =
        PreviousMisconductReportedForm.new(
          previous_misconduct_reported_form_params.merge(
            referral: current_referral
          )
        )
      if @previous_misconduct_reported_form.save
        redirect_to referral_previous_misconduct_path(current_referral)
      else
        render :edit
      end
    end

    private

    def previous_misconduct_reported_form_params
      params.require(:previous_misconduct_reported_form).permit(
        :previous_misconduct_reported
      )
    end
  end
end
