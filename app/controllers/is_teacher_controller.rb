class IsTeacherController < EligibilityScreenerController
  def new
    @is_teacher_form = IsTeacherForm.new
  end

  def create
    @is_teacher_form =
      IsTeacherForm.new(is_teacher_form_params.merge(eligibility_check:))
    if @is_teacher_form.save
      next_question
    else
      render :new
    end
  end

  private

  def is_teacher_form_params
    params.require(:is_teacher_form).permit(:is_teacher)
  end
end
