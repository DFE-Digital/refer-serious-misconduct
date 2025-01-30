class PagesController < ApplicationController
  def start
    redirect_to StartPath.for(user: current_user) and return
  end

  def you_should_know
    return redirect_to(start_path) if eligibility_check.nil?

    @previous_path =
      if eligibility_check.reporting_as_public?
        public_teaching_in_england_path
      else
        serious_misconduct_path
      end

    @continue_path =
      if FeatureFlags::FeatureFlag.active?(:referral_form)
        if !current_user
          new_user_session_path(new_referral: true)
        elsif eligibility_check.reporting_as_public?
          new_public_referral_path
        else
          new_referral_path
        end
      else
        complete_path
      end
    @public = eligibility_check.reporting_as_public?
  end

  def complete
    return redirect_to(start_path) if eligibility_check.nil?
    session[:eligibility_check_id] = nil
  end

  private

  def eligibility_check
    @eligibility_check ||= EligibilityCheck.find_by(id: session[:eligibility_check_id])
  end
end
