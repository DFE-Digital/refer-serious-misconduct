module PublicEligibilityScreener
  class IsTeacherController < PublicEligibilityScreenerController
    def new
      @is_teacher_form = PublicEligibilityScreener::IsTeacherForm.new(eligibility_check:)
    end

    def create
      @is_teacher_form =
        PublicEligibilityScreener::IsTeacherForm.new(is_teacher_form_params.merge(eligibility_check:))

      if @is_teacher_form.save
        redirect_to_next_question
      else
        render :new
      end
    end

    private

    def is_teacher_form_params
      params.require(:public_eligibility_screener_is_teacher_form).permit(:is_teacher)
    end
  end
end
