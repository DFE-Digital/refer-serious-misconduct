class Referrals::PreviousMisconductController < Referrals::BaseController
  def show
    @previous_misconduct_form =
      PreviousMisconductForm.new(referral: current_referral)
  end

  def update
    @previous_misconduct_form =
      PreviousMisconductForm.new(
        complete: previous_misconduct_params[:complete],
        referral: current_referral
      )

    if @previous_misconduct_form.save
      redirect_to [:edit, current_referral.routing_scope, current_referral]
    else
      render :show
    end
  end

  private

  def previous_misconduct_params
    params.require(:previous_misconduct_form).permit(:complete)
  end
end
