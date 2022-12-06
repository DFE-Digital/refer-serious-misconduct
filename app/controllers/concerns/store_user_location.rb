# frozen_string_literal: true
module StoreUserLocation
  extend ActiveSupport::Concern

  included { before_action :store_user_location!, if: :storable_location? }

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? &&
      !request.xhr?
  end

  def store_user_location!
    store_location_for(:user, request.fullpath)
  end
end
