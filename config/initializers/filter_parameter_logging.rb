# Be sure to restart your server when you modify this file.

# Configure parameters to be filtered from the log file. Use this to limit dissemination of
# sensitive information. See the ActiveSupport::ParameterFilter documentation for supported
# notations and behaviors.
Rails.application.config.filter_parameters += %i[
  passw
  secret
  token
  _key
  crypt
  salt
  certificate
  otp
  email
  ssn
  first_name
  last_name
  date_of_birth
  previous_name
  phone_number
  phone
  trn
  duties_details
  allegation_consideration_details
  previous_misconduct_details
  current_sign_in_ip
  last_sign_in_ip
  ni_number
  unconfirmed_email
]
