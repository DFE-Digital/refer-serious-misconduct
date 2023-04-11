class OrganisationComponent < ViewComponent::Base
  include ActiveModel::Model
  include AddressHelper
  include ReferralHelper
  include ComponentHelper

  attr_accessor :referral

  delegate :organisation, to: :referral

  def rows
    items = summary_rows [organisation_row].compact

    referral.submitted? ? remove_actions(items) : items
  end

  private

  def organisation_row
    {
      label: "Your organisation",
      value: organisation_address(organisation),
      path: :organisation_address
    }
  end
end
