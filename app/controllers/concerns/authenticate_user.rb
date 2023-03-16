# frozen_string_literal: true
module AuthenticateUser
  extend ActiveSupport::Concern

  included { before_action :authenticate_user!, if: -> { FeatureFlags::FeatureFlag.active?(:referral_form) } }
end
