# frozen_string_literal: true

class NavigationComponent < ViewComponent::Base
  include ReferralHelper

  attr_accessor :current_user, :current_staff

  def initialize(current_user:, current_staff:)
    super
    @current_user = current_user
    @current_staff = current_staff
  end

  def current_namespace
    request.path.split("/").second
  end

  def homepage_url
    "https://www.gov.uk/"
  end

  def service_url
    if current_user && current_user.latest_referral
      edit_path_for(current_user.latest_referral)
    else
      root_path
    end
  end
end
