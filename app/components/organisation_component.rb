class OrganisationComponent < ViewComponent::Base
  include ActiveModel::Model
  include AddressHelper

  include Rails.application.routes.url_helpers

  attr_accessor :referral

  attr_writer :editable

  def editable
    @editable || false
  end

  delegate :organisation, to: :referral

  def rows
    [
      {
        actions:,
        key: {
          text: "Your organisation"
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

  def actions
    return [] unless editable

    [
          {
            text: "Change",
            href: [
              :edit,
              referral.routing_scope,
              referral,
              :organisation,
              :address,
              { return_to:}

            ],
            visually_hidden_text: "your organisation"
          }
    ]
  end
end
