module PublicEligibilityScreener
  class UnsupervisedTeachingController < PublicEligibilityScreenerController
    def new
      @unsupervised_teaching_form =
        PublicEligibilityScreener::UnsupervisedTeachingForm.new(eligibility_check:)
    end

    def create
      @unsupervised_teaching_form =
        PublicEligibilityScreener::UnsupervisedTeachingForm.new(
          public_unsupervised_teaching_form_params.merge(eligibility_check:)
        )

      if @unsupervised_teaching_form.save
        if eligibility_check.unsupervised_teaching?
          redirect_to_next_question
        else
          redirect_to(no_jurisdiction_unsupervised_path)
        end
      else
        render :new
      end
    end

    private

    def public_unsupervised_teaching_form_params
      params.require(:public_eligibility_screener_unsupervised_teaching_form).permit(
        :unsupervised_teaching
      )
    end
  end
end
