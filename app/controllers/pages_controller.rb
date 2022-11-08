class PagesController < ApplicationController
  def complete
    @eligibility_check =
      EligibilityCheck.find_by(id: session[:eligibility_check_id])
    return redirect_to(start_path) if @eligibility_check.nil?
    session[:eligibility_check_id] = nil
  end

  def start
    @start_now_path = (current_user ? who_path : new_user_session_path)
  end
end
