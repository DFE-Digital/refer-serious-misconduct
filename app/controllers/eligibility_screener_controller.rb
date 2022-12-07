class EligibilityScreenerController < ApplicationController
  include StoreUserLocation
  include AuthenticateUser
  include EnforceQuestionOrder
  include RedirectIfFeatureFlagInactive

  before_action { redirect_if_feature_flag_inactive(:eligibility_screener) }
end
