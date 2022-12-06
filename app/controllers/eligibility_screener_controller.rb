class EligibilityScreenerController < ApplicationController
  include AuthenticateUser
  include StoreUserLocation
  include EnforceQuestionOrder
  include RedirectIfFeatureFlagInactive

  before_action { redirect_if_feature_flag_inactive(:eligibility_screener) }
end
