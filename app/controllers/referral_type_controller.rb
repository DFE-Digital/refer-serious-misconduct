class ReferralTypeController < EligibilityScreenerController
  def new
    @reporting_as_form = ReportingAsForm.new(eligibility_check:)
  end

  def create
    @reporting_as_form = ReportingAsForm.new(reporting_as_params.merge(eligibility_check:))

    if @reporting_as_form.save
      assign_eligibility_check_to_session
      redirect_to_next_question
    else
      render :new
    end
  end

  private

  def reporting_as_params
    params.require(:reporting_as_form).permit(:reporting_as)
  end
end
