class HaveComplainedController < Referrals::BaseController
  include EnforceQuestionOrder

  def new
    @have_complained_form = HaveComplainedForm.new(eligibility_check:)
  end

  def create
    @have_complained_form =
      HaveComplainedForm.new(
        have_complained_form_params.merge(eligibility_check:)
      )
    if @have_complained_form.save
      if eligibility_check.complained?
        next_question
      else
        redirect_to(no_complaint_path)
      end
    else
      render :new
    end
  end

  private

  def have_complained_form_params
    params.require(:have_complained_form).permit(:complained)
  end
end
