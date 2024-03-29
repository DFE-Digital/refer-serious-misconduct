module PublicEligibilityScreener
  class TeachingInEnglandController < PublicEligibilityScreenerController
    def new
      @teaching_in_england_form = PublicEligibilityScreener::TeachingInEnglandForm.new(eligibility_check:)
    end

    def create
      @teaching_in_england_form =
        PublicEligibilityScreener::TeachingInEnglandForm.new(
          teaching_in_england_form_params.merge(eligibility_check:)
        )

      if @teaching_in_england_form.save
        if eligibility_check.teaching_in_england?
          redirect_to_next_question
        else
          redirect_to(no_jurisdiction_path)
        end
      else
        render :new
      end
    end

    private

    def teaching_in_england_form_params
      params.require(:public_eligibility_screener_teaching_in_england_form).permit(:teaching_in_england)
    end
  end
end
