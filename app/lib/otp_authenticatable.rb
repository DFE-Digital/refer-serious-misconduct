# frozen_string_literal: true

require "devise"
require "devise/strategies/authenticatable"

class OtpAuthenticatable < Devise::Strategies::Authenticatable
  #undef :password
  #undef :password=

  attr_accessor :otp, :email

  def valid_for_http_auth?
    super && http_auth_hash[:otp].present?
  end

  def valid_for_params_auth?
    super && params_auth_hash[:otp].present?
  end

  def authenticate!
    resource = mapping.to.find_by(email:)
    unless resource && resource.secret_key.present?
      fail(:otp_invalid)
      return
    end

    # TODO: handle expired OTPs

    otp_generator = ROTP::HOTP.new(resource.secret_key)
    derived_otp = otp_generator.at(0)

    unless derived_otp == otp
      fail(:otp_invalid)
      return
    end

    if validate(resource)
      remember_me(resource)
      resource.after_otp_authentication
      success!(resource)
    else
      fail(:otp_invalid)
    end
  end

  private

  # Sets the authentication hash and the token from params_auth_hash or http_auth_hash.
  def with_authentication_hash(auth_type, auth_values)
    self.authentication_hash = {}
    self.authentication_type = auth_type
    self.email = auth_values[:email]
    self.otp = auth_values[:otp]

    parse_authentication_key_values(auth_values, authentication_keys) &&
      parse_authentication_key_values(request_values, request_keys)
  end
end

