class OrganisationComponent < ViewComponent::Base
  include ActiveModel::Model
  include AddressHelper

  attr_accessor :referral

  delegate :organisation, to: :referral

  def rows
    [
      {
        actions: [
          {
            text: "Change",
            href:
              edit_referral_organisation_name_path(
                referral,
                return_to: request.url
              ),
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
            href:
              edit_referral_organisation_address_path(
                referral,
                return_to: request.url
              ),
            visually_hidden_text: "address"
          }
        ],
        key: {
          text: "Address"
        },
        value: {
          text: organisation_address(organisation)
        }
      }
    ]
  end
end
