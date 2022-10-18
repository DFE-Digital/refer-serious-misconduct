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
      next_question
    else
      render :new
    end
  end

  private

  def serious_misconduct_form_params
    params.require(:serious_misconduct_form).permit(:serious_misconduct)
  end
end
