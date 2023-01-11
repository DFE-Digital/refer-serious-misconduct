class ReferralTypeController < EligibilityScreenerController
  skip_before_action :authenticate_user!

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
