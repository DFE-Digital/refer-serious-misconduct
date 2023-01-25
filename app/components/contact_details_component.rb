class ContactDetailsComponent < ViewComponent::Base
  include ActiveModel::Model
  include AddressHelper

  attr_accessor :referral

  def rows
    [
      {
        actions: [
          {
            text: "Change",
            href: path_for(:email),
            visually_hidden_text: "email"
          }
        ],
        key: {
          text: "Email address"
        },
        value: {
          text: referral.email_known ? referral.email_address : "Not known"
        }
      },
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
          text: referral.phone_known ? referral.phone_number : "Not known"
        }
      },
      {
        actions: [
          {
            text: "Change",
            href: path_for(:address),
            visually_hidden_text: "address"
          }
        ],
        key: {
          text: "Address"
        },
        value: {
          text: referral.address_known ? address(referral) : "Not known"
        }
      }
    ]
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
end
