class OrganisationComponent < ViewComponent::Base
  include ActiveModel::Model

  attr_accessor :referral

  delegate :organisation, to: :referral

  def organisation_address
    [
      organisation.street_1,
      organisation.street_2,
      organisation.city,
      organisation.postcode
    ].compact_blank.join("<br />").html_safe
  end

  def rows
    [
      {
        actions: [
          {
            text: "Change",
            href: edit_referral_organisation_name_path(referral),
            visually_hidden_text: "name"
          }
        ],
        key: {
          text: "Organisation"
        },
        value: {
          text: organisation.name
        }
      },
      {
        actions: [
          {
            text: "Change",
            href: edit_referral_organisation_address_path(referral),
            visually_hidden_text: "address"
          }
        ],
        key: {
          text: "Address"
        },
        value: {
          text: organisation_address
        }
      }
    ]
  end
end
