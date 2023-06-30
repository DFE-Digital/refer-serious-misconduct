# frozen_string_literal: true

class FeedbacksController < ApplicationController
  def new
    @feedback = Feedback.new
  end

  def create
    @feedback = Feedback.new(feedback_params)

    if @feedback.save
      redirect_to :confirmation
    else
      render(:new)
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(
      :satisfaction_rating,
      :improvement_suggestion,
      :contact_permission_given,
      :email
    )
  end
end
