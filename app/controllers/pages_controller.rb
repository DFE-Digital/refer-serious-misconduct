class PagesController < ApplicationController
  def complete
    @eligibility_check = EligibilityCheck.find(session[:eligibility_check_id])
  end

  def start
  end
end
