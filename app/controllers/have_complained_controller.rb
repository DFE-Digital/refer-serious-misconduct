class HaveComplainedController < EligibilityScreenerController
  def new
    @have_complained_form = HaveComplainedForm.new(eligibility_check:)
  end

  def create
    @have_complained_form =
      HaveComplainedForm.new(have_complained_form_params.merge(eligibility_check:))

    if @have_complained_form.save
      eligibility_check.complained? ? redirect_to_next_question : redirect_to(no_complaint_path)
    else
      render :new
    end
  end

  private

  def have_complained_form_params
    params.require(:have_complained_form).permit(:complained)
  end
end
