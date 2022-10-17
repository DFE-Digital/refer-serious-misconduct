class SeriousMisconductController < ApplicationController
  def new
    @serious_misconduct_form = SeriousMisconductForm.new
  end

  def create
    @serious_misconduct_form =
      SeriousMisconductForm.new(
        serious_misconduct_form_params.merge(eligibility_check:)
      )
    if @serious_misconduct_form.save
      redirect_to @serious_misconduct_form.success_url
    else
      render :new
    end
  end

  private

  def eligibility_check
    @eligibility_check ||=
      EligibilityCheck.find_by(id: session[:eligibility_check_id])
  end

  def serious_misconduct_form_params
    params.require(:serious_misconduct_form).permit(:serious_misconduct)
  end
end
