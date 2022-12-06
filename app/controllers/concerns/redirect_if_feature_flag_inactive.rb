# frozen_string_literal: true
module RedirectIfFeatureFlagInactive
  extend ActiveSupport::Concern

  def redirect_if_feature_flag_inactive(feature, path = start_path)
    return if FeatureFlags::FeatureFlag.active?(feature)

    redirect_to(path) && return
  end
end
