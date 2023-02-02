class Referrals::PreviousMisconductController < Referrals::BaseController
  def show
    @previous_misconduct_form =
      PreviousMisconductForm.new(
        previous_misconduct_complete:
          current_referral.previous_misconduct_complete
      )
  end

  def update
    @previous_misconduct_form =
      PreviousMisconductForm.new(
        previous_misconduct_params.merge(referral: current_referral)
      )

    if @previous_misconduct_form.save
      redirect_to [:edit, current_referral.routing_scope, current_referral]
    else
      render :show
    end
  end

  private

  def previous_misconduct_params
    params.require(:previous_misconduct_form).permit(
      :previous_misconduct_complete
    )
  end
end
