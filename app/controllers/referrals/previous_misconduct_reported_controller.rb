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
        if current_referral.previous_misconduct_reported?
          redirect_to edit_referral_previous_misconduct_summary_path(
                        current_referral
                      )
        else
          redirect_to referral_previous_misconduct_path(current_referral)
        end
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
