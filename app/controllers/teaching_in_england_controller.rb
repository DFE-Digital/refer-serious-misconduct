class TeachingInEnglandController < EligibilityScreenerController
  def new
    @teaching_in_england_form = TeachingInEnglandForm.new(eligibility_check:)
  end

  def create
    @teaching_in_england_form =
      TeachingInEnglandForm.new(
        teaching_in_england_form_params.merge(eligibility_check:)
      )
    if @teaching_in_england_form.save
      if eligibility_check.teaching_in_england?
        next_question
      else
        redirect_to(no_jurisdiction_path)
      end
    else
      render :new
    end
  end

  private

  def eligibility_check
    @eligibility_check ||=
      EligibilityCheck.find_by(id: session[:eligibility_check_id])
  end

  def teaching_in_england_form_params
    params.require(:teaching_in_england_form).permit(:teaching_in_england)
  end
end
