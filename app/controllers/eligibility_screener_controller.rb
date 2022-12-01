class EligibilityScreenerController < ApplicationController
  include AuthenticateUser
  include StoreUserLocation
  include EnforceQuestionOrder
  include RedirectIfFeatureFlagInactive

  before_action { redirect_if_feature_flag_inactive(:employer_form) }
end
