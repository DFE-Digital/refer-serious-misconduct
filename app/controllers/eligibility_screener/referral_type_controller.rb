module EligibilityScreener
  class ReferralTypeController < EligibilityScreenerController
    def new
      eligibility_check.clear_answers! if from_users_journey?

      @reporting_as_form = EligibilityScreener::ReportingAsForm.new(eligibility_check:)
    end

    def create
      @reporting_as_form =
        EligibilityScreener::ReportingAsForm.new(reporting_as_params.merge(eligibility_check:))

      if @reporting_as_form.save
        assign_eligibility_check_to_session
        redirect_to_next_question
      else
        render :new
      end
    end

    private

    def reporting_as_params
      params.require(:eligibility_screener_reporting_as_form).permit(:reporting_as)
    end

    def from_users_journey?
      request.referer&.include?("users/referrals")
    end
  end
end
