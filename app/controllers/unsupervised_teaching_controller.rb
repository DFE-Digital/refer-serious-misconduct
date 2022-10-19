class UnsupervisedTeachingController < ApplicationController
  def new
    @unsupervised_teaching_form = UnsupervisedTeachingForm.new
  end

  def create
    @unsupervised_teaching_form =
      UnsupervisedTeachingForm.new(
        unsupervised_teaching_form_params.merge(eligibility_check:)
      )
    if @unsupervised_teaching_form.save
      next_question
    else
      render :new
    end
  end

  private

  def unsupervised_teaching_form_params
    params.require(:unsupervised_teaching_form).permit(:unsupervised_teaching)
  end
end
