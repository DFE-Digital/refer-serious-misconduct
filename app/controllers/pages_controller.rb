class PagesController < ApplicationController
  def start
    @start_now_path =
      if FeatureFlags::FeatureFlag.active?(:user_accounts)
        current_user ? who_path : new_user_session_path
      else
        who_path
      end
  end

  def you_should_know
    @continue_path =
      if FeatureFlags::FeatureFlag.active?(:user_accounts)
        new_referral_path
      else
        complete_path
      end
  end

  def complete
    @eligibility_check =
      EligibilityCheck.find_by(id: session[:eligibility_check_id])
    return redirect_to(start_path) if @eligibility_check.nil?
    session[:eligibility_check_id] = nil
  end
end
