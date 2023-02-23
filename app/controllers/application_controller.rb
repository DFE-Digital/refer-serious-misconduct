class ApplicationController < ActionController::Base
  include Pagy::Backend
  default_form_builder(GOVUKDesignSystemFormBuilder::FormBuilder)

  http_basic_authenticate_with(
    name: ENV.fetch("SUPPORT_USERNAME", nil),
    password: ENV.fetch("SUPPORT_PASSWORD", nil),
    unless: -> { FeatureFlags::FeatureFlag.active?("service_open") }
  )

  private

  def referrals_redirect
    redirect_to users_referrals_path and return if referrals_submitted?

    referral_in_progress = current_user&.referral_in_progress

    return unless referral_in_progress

    redirect_to [
                  :edit,
                  referral_in_progress.routing_scope,
                  referral_in_progress
                ]
  end

  def referrals_submitted?
    current_user&.referrals&.submitted&.present?
  end
end
