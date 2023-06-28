module EligibilityScreener
  class ContinueWithController < EligibilityScreenerController
    def new
      @continue_with_form = EligibilityScreener::ContinueWithForm.new(eligibility_check:)
    end

    def create
      @continue_with_form =
        EligibilityScreener::ContinueWithForm.new(
          continue_with_form_params.merge(eligibility_check:)
        )

      if @continue_with_form.save
        if eligibility_check.continue_with_referral?
          redirect_to(you_should_know_path)
        else
          redirect_to(make_a_complaint_path)
        end
      else
        render :new
      end
    end

    private

    def continue_with_form_params
      params.require(:eligibility_screener_continue_with_form).permit(:continue_with)
    end
  end
end
