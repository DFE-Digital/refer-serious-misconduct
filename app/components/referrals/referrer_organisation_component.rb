module Referrals
  class ReferrerOrganisationComponent < ReferralFormBaseComponent
    def all_rows
      summary_rows [organisation_row]
    end

    private

    def organisation_row
      { label: "Your organisation", value: organisation_address(organisation), path: :address }
    end

    def section
      Referrals::Sections::ReferrerOrganisationSection.new(referral:)
    end
  end
end
