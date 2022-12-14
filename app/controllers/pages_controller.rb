class PagesController < ApplicationController
  def start
    @start_now_path =
      if FeatureFlags::FeatureFlag.active?(:referral_form)
        current_user ? who_path : new_user_session_path
      else
        who_path
      end
  end

  def you_should_know
    @continue_path =
      if FeatureFlags::FeatureFlag.active?(:referral_form)
        if eligibility_check.reporting_as_public?
          new_public_referral_path
        else
          new_referral_path
        end
      else
        complete_path
      end
  end

  def complete
    return redirect_to(start_path) if eligibility_check.nil?
    session[:eligibility_check_id] = nil
  end

  private

  def eligibility_check
    @eligibility_check ||=
      EligibilityCheck.find_by(id: session[:eligibility_check_id])
  end
end
