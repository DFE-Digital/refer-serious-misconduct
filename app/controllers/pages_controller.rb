class PagesController < ApplicationController
  skip_before_action :redirect_to_next_question

  def complete
    @eligibility_check =
      EligibilityCheck.find_by(id: session[:eligibility_check_id])
    return redirect_to(start_path) if @eligibility_check.nil?
    reset_session
  end

  def start
  end
end
