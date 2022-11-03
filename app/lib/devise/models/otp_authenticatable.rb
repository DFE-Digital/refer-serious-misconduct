# frozen_string_literal: true

module Devise::Models::OtpAuthenticatable
  extend ActiveSupport::Concern

  included do
    attr_reader :otp
  end

  def password_required?
    false
  end

  def password
    nil
  end

  def after_otp_authentication
    update(secret_key: nil)
  end
end

