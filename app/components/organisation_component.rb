class OrganisationComponent < ViewComponent::Base
  include ActiveModel::Model
  include AddressHelper
  include ReferralHelper
  include ComponentHelper

  delegate :organisation, to: :referral

  def rows
    summary_rows [organisation_row].compact
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
