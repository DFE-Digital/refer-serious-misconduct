class EligibilityScreenerController < ApplicationController
  include EnforceQuestionOrder
  include RedirectIfFeatureFlagInactive

  before_action { redirect_if_feature_flag_inactive(:eligibility_screener) }

  private

  # Eligibility check is saved in the form objects
  def eligibility_check
    @eligibility_check ||=
      EligibilityCheck.find_or_initialize_by(id: session[:eligibility_check_id])
  end

  def assign_eligibility_check_to_session
    session[:eligibility_check_id] ||= eligibility_check.reload.id
  end
end
