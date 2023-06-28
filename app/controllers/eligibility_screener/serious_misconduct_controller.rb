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
        if eligibility_check.serious_misconduct?
          redirect_to(you_should_know_path)
        else
          redirect_to(not_serious_misconduct_path)
        end
      else
        render :new
      end
    end

    private

    def serious_misconduct_form_params
      params.require(:eligibility_screener_serious_misconduct_form).permit(:serious_misconduct)
    end
  end
end
