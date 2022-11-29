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
          redirect_to next_page
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

    def next_path
      edit_referral_previous_misconduct_detailed_account_path(current_referral)
    end

    def next_page
      if @previous_misconduct_reported_form.referral.saved_changes?
        return next_path
      end

      super
    end
  end
end
