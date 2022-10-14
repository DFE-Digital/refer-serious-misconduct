class ReportingAsController < ApplicationController
  def new
    @reporting_as_form = ReportingAsForm.new
  end

  def create
    eligibility_check = EligibilityCheck.new
    @reporting_as_form =
      ReportingAsForm.new(reporting_as_params.merge(eligibility_check:))
    if @reporting_as_form.save
      redirect_to confirmation_path
    else
      render :new
    end
  end

  private

  def reporting_as_params
    params.require(:reporting_as_form).permit(:reporting_as)
  end
end
