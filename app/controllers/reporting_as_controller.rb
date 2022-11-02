class ReportingAsController < ApplicationController
  include EnforceQuestionOrder

  # TODO: remove this, for demo only
  before_action :authenticate_user!, only: [:new]

  def new
    @reporting_as_form = ReportingAsForm.new(eligibility_check:)
  end

  def create
    @reporting_as_form =
      ReportingAsForm.new(reporting_as_params.merge(eligibility_check:))
    if @reporting_as_form.save
      session[:eligibility_check_id] = eligibility_check.id
      next_question
    else
      render :new
    end
  end

  private

  def reporting_as_params
    params.require(:reporting_as_form).permit(:reporting_as)
  end
end
