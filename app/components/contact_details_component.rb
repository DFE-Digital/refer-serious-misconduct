class ContactDetailsComponent < ViewComponent::Base
  include ActiveModel::Model
  include AddressHelper

  attr_accessor :referral

  def rows
    rows = [email_known_row]
    rows.push(email_row) if referral.email_known
    rows.push(phone_number_known_row)
    rows.push(phone_number_row) if referral.phone_known
    rows.push(address_known_row)
    rows.push(address_row) if referral.address_known
    rows
  end

  def path_for(part)
    [
      :edit,
      referral.routing_scope,
      referral,
      :contact_details,
      part,
      { return_to: }
    ]
  end

  def return_to
    polymorphic_path(
      [:edit, referral.routing_scope, referral, :contact_details_check_answers]
    )
  end

  def email_known_row
    {
      actions: [
        {
          text: "Change",
          href: path_for(:email),
          visually_hidden_text: "if you know their email address"
        }
      ],
      key: {
        text: "Do you know their email address?"
      },
      value: {
        text: referral.email_known ? "Yes" : "No"
      }
    }
  end

  def email_row
    {
      actions: [
        {
          text: "Change",
          href: path_for(:email),
          visually_hidden_text: "email address"
        }
      ],
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
      actions: [
        {
          text: "Change",
          href: path_for(:telephone),
          visually_hidden_text: "if you know their phone number"
        }
      ],
      key: {
        text: "Do you know their phone number?"
      },
      value: {
        text: referral.phone_known ? "Yes" : "No"
      }
    }
  end

  def phone_number_row
    {
      actions: [
        {
          text: "Change",
          href: path_for(:telephone),
          visually_hidden_text: "phone number"
        }
      ],
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
        {
          text: "Change",
          href: path_for(:address_known),
          visually_hidden_text: "if you know their home address"
        }
      ],
      key: {
        text: "Do you know their home address?"
      },
      value: {
        text: referral.address_known ? "Yes" : "No"
      }
    }
  end

  def address_row
    {
      actions: [
        {
          text: "Change",
          href: path_for(:address),
          visually_hidden_text: "home address"
        }
      ],
      key: {
        text: "Home address"
      },
      value: {
        text: address(referral)
      }
    }
  end
end
