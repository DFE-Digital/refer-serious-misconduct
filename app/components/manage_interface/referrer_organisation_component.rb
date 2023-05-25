module ManageInterface
  class ReferrerOrganisationComponent < ViewComponent::Base
    include ActiveModel::Model
    include ReferralHelper
    include AddressHelper

    attr_accessor :referral

    def rows
      summary_rows [organisation_row]
    end

    def title
      "Other employment details"
    end

    private

    def organisation_row
      { label: "Organisation", value: teaching_address(referral) }
    end
  end
end
