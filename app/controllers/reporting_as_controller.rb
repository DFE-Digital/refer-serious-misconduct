class ReportingAsController < ApplicationController
  def new
    @reporting_as_form = ReportingAsForm.new
  end

  def create
    eligibility_check = EligibilityCheck.new
    @reporting_as_form =
      ReportingAsForm.new(reporting_as_params.merge(eligibility_check:))
    if @reporting_as_form.save
      session[:eligibility_check_id] = eligibility_check.id
      redirect_to you_should_know_path
    else
      render :new
    end
  end

  private

  def reporting_as_params
    params.require(:reporting_as_form).permit(:reporting_as)
  end
end
