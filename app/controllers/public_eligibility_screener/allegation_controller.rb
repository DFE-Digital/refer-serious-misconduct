module PublicEligibilityScreener
  class AllegationController < PublicEligibilityScreenerController
    def new
      @allegation_form = PublicEligibilityScreener::AllegationForm.new(eligibility_check:)
    end

    def create
      @allegation_form =
        PublicEligibilityScreener::AllegationForm.new(allegation_params.merge(eligibility_check:))

      if @allegation_form.save
        redirect_to_next_question
      else
        render :new
      end
    end

      private

    def allegation_params
      params.require(:public_eligibility_screener_allegation_form).permit(serious_misconduct: [])
    end
  end
end
