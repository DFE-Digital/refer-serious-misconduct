class OrganisationComponent < ViewComponent::Base
  include ActiveModel::Model
  include AddressHelper
  include ComponentHelper
  include ReferralHelper

  attr_accessor :referral

  delegate :organisation, to: :referral

  def rows
    items = [
      {
        actions: [
          {
            text: "Change",
            href: [:edit, referral.routing_scope, referral, :organisation, :address, { return_to: }],
            visually_hidden_text: "your organisation"
          }
        ],
        key: {
          text: "Your organisation"
        },
        value: {
          text: nullable_value_to_s(organisation_address(organisation).presence)
        }
      }
    ]

    referral.submitted? ? remove_actions(items) : items
  end

  def return_to
    polymorphic_path([:edit, referral.routing_scope, referral, :organisation, :check_answers])
  end
end
