class OrganisationComponent < ViewComponent::Base
  include ActiveModel::Model
  include AddressHelper
  include ComponentHelper

  attr_accessor :referral

  delegate :organisation, to: :referral

  def rows
    items = [
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
            visually_hidden_text: "your organisation"
          }
        ],
        key: {
          text: "Your organisation"
        },
        value: {
          text: organisation_address(organisation)
        }
      }
    ]

    referral.submitted? ? remove_actions(items) : items
  end

  def return_to
    polymorphic_path([referral.routing_scope, referral, :organisation])
  end
end
