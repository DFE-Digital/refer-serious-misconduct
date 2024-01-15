module EligibilityScreener
  class ReferralTypeController < EligibilityScreenerController
    def new
      eligibility_check.clear_answers! if from_users_journey?

      @reporting_as_form = EligibilityScreener::ReportingAsForm.new(eligibility_check:)
    end

    def create
      set_reporting_as_form

      if @reporting_as_form.save && employer_journey?
        assign_eligibility_check_to_session
        redirect_to_next_question
      elsif @reporting_as_form.save && public_journey?
        assign_eligibility_check_to_session
        redirect_to complained_about_teacher_path
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

    def set_reporting_as_form
      if public_journey?
        @reporting_as_form =
          PublicEligibilityScreener::ReportingAsForm.new(reporting_as_params.merge(eligibility_check:))
      else
        @reporting_as_form =
          EligibilityScreener::ReportingAsForm.new(reporting_as_params.merge(eligibility_check:))
      end
    end

    def employer_journey?
      reporting_as_params[:reporting_as] == "employer"
    end

    def public_journey?
      reporting_as_params[:reporting_as] == "public"
    end
  end
end
