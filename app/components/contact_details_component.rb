class ContactDetailsComponent < ViewComponent::Base
  include ActiveModel::Model
  include AddressHelper
  include ComponentHelper
  include ReferralHelper

  attr_accessor :referral

  def rows
    items = [email_known_row]
    items.push(email_row) if referral.email_known
    items.push(phone_number_known_row)
    items.push(phone_number_row) if referral.phone_known
    items.push(address_known_row)
    items.push(address_row) if referral.address_known
    referral.submitted? ? remove_actions(items) : items
  end

  def path_for(part)
    [:edit, referral.routing_scope, referral, :contact_details, part, { return_to: }]
  end

  def return_to
    polymorphic_path([:edit, referral.routing_scope, referral, :contact_details_check_answers])
  end

  def email_known_row
    {
      actions: [{ text: "Change", href: path_for(:email), visually_hidden_text: "if you know their email address" }],
      key: {
        text: "Do you know their email address?"
      },
      value: {
        text: nullable_boolean_to_s(referral.email_known)
      }
    }
  end

  def email_row
    {
      actions: [{ text: "Change", href: path_for(:email), visually_hidden_text: "email address" }],
      key: {
        text: "Email address"
      },
      value: {
        text: referral.email_known ? referral.email_address : "Not known"
      }
    }
  end

  def phone_number_known_row
    {
      actions: [{ text: "Change", href: path_for(:telephone), visually_hidden_text: "if you know their phone number" }],
      key: {
        text: "Do you know their phone number?"
      },
      value: {
        text: nullable_boolean_to_s(referral.phone_known)
      }
    }
  end

  def phone_number_row
    {
      actions: [{ text: "Change", href: path_for(:telephone), visually_hidden_text: "phone number" }],
      key: {
        text: "Phone number"
      },
      value: {
        text: referral.phone_number
      }
    }
  end

  def address_known_row
    {
      actions: [
        { text: "Change", href: path_for(:address_known), visually_hidden_text: "if you know their home address" }
      ],
      key: {
        text: "Do you know their home address?"
      },
      value: {
        text: nullable_boolean_to_s(referral.address_known)
      }
    }
  end

  def address_row
    {
      actions: [{ text: "Change", href: path_for(:address), visually_hidden_text: "home address" }],
      key: {
        text: "Home address"
      },
      value: {
        text: nullable_value_to_s(address(referral).presence)
      }
    }
  end
end
