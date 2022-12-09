# frozen_string_literal: true
module AuthenticateUser
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!,
                  if: -> { FeatureFlags::FeatureFlag.active?(:employer_form) }
  end
end
