class ApplicationController < ActionController::Base
  include Pagy::Backend
  default_form_builder(GOVUKDesignSystemFormBuilder::FormBuilder)

  http_basic_authenticate_with(
    name: ENV.fetch("SUPPORT_USERNAME", nil),
    password: ENV.fetch("SUPPORT_PASSWORD", nil),
    unless: -> { FeatureFlags::FeatureFlag.active?("service_open") }
  )

  private

  def redirect_to_referral_if_exists
    latest_referral = current_user&.latest_referral

    if latest_referral
      redirect_to [:edit, latest_referral.routing_scope, latest_referral]
    end
  end
end
