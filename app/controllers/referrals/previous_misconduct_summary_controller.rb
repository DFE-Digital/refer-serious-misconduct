class Referrals::PreviousMisconductSummaryController < Referrals::BaseController
  def edit
    @previous_misconduct_summary_form =
      PreviousMisconductSummaryForm.new(referral: current_referral)
  end

  def update
    @previous_misconduct_summary_form =
      PreviousMisconductSummaryForm.new(
        previous_misconduct_summary_form_params.merge(
          referral: current_referral
        )
      )
    if @previous_misconduct_summary_form.save
      redirect_to referral_previous_misconduct_path(current_referral)
    else
      render :edit
    end
  end

  private

  def previous_misconduct_summary_form_params
    params.require(:previous_misconduct_summary_form).permit(:summary)
  end
end
