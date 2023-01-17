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
            href: [
              :edit,
              referral.routing_scope,
              referral,
              :organisation,
              :name,
              { return_to: }
            ],
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
            href: [
              :edit,
              referral.routing_scope,
              referral,
              :organisation,
              :address,
              { return_to: }
            ],
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

  def return_to
    polymorphic_path([referral.routing_scope, referral, :organisation])
  end
end
