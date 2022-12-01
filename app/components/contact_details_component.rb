class ContactDetailsComponent < ViewComponent::Base
  include ActiveModel::Model

  attr_accessor :referral

  def rows
    [
      {
        actions: [
          {
            text: "Change",
            href: referrals_edit_contact_details_email_path(referral),
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
            href: referrals_edit_contact_details_address_path(referral),
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
end
