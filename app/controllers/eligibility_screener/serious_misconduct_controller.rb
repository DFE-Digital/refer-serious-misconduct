module EligibilityScreener
  class SeriousMisconductController < EligibilityScreenerController
    def new
      @serious_misconduct_form = EligibilityScreener::SeriousMisconductForm.new(eligibility_check:)
    end

    def create
      @serious_misconduct_form =
        EligibilityScreener::SeriousMisconductForm.new(
          serious_misconduct_form_params.merge(eligibility_check:)
        )

      if @serious_misconduct_form.save
        redirect_to_next_question
      else
        render :new
      end
    end

    private

    def serious_misconduct_form_params
      params.require(:eligibility_screener_serious_misconduct_form).permit(:continue_with)
    end
  end
end
