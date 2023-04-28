class ContactDetailsComponent < ViewComponent::Base
  include ActiveModel::Model
  include AddressHelper
  include ComponentHelper
  include ReferralHelper

  def rows
    summary_rows [
                   email_known_row,
                   referral.email_known? && email_row,
                   phone_number_known_row,
                   referral.phone_known? && phone_number_row,
                   address_known_row,
                   referral.address_known? && address_row
                 ].compact_blank
  end

  private

  def email_known_row
    {
      label: "Do you know their email address?",
      value: referral.email_known,
      visually_hidden_text: "if you know their email address",
      path: :contact_details_email
    }
  end

  def email_row
    { label: "Email address", value: referral.email_address, path: :contact_details_email }
  end

  def phone_number_known_row
    {
      label: "Do you know their phone number?",
      value: referral.phone_known,
      visually_hidden_text: "if you know their phone number",
      path: :contact_details_telephone
    }
  end

  def phone_number_row
    { label: "Phone number", value: referral.phone_number, path: :contact_details_telephone }
  end

  def address_known_row
    {
      label: "Do you know their home address?",
      value: referral.address_known,
      visually_hidden_text: "if you know their home address",
      path: :contact_details_address_known
    }
  end

  def address_row
    { label: "Home address", value: address(referral).presence, path: :contact_details_address }
  end
end
