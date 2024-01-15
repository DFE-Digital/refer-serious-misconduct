class PublicEligibilityScreenerController < ApplicationController
  include PublicEnforceQuestionOrder
  include RedirectIfFeatureFlagInactive

  before_action { redirect_if_feature_flag_inactive(:eligibility_screener) }

  def previous_question_path
    previous_question&.dig(:path) || start_path
  end

  def eligibility_check
    @eligibility_check ||=
      EligibilityCheck.find_or_initialize_by(id: session[:eligibility_check_id])
  end

  def assign_eligibility_check_to_session
    session[:eligibility_check_id] ||= eligibility_check.reload.id
  end
  helper_method :previous_question_path
end