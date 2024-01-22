module PublicEligibilityScreener
  class ComplainedToSchoolController < PublicEligibilityScreenerController
    def new
      @complained_to_school_form = PublicEligibilityScreener::ComplainedToSchoolForm.new(eligibility_check:)
    end

    def create
      @complained_to_school_form =
        PublicEligibilityScreener::ComplainedToSchoolForm.new(
          complained_to_school_form_params.merge(eligibility_check:))

      if @complained_to_school_form.save
        redirect_to_next_question
      else
        render :new
      end
    end

    def complained_to_school_form_params
      params.require(:public_eligibility_screener_complained_to_school_form).permit(:complaint_status)
    end
  end
end