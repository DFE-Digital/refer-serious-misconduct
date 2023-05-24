module Referrals
  class OrganisationComponent < ReferralFormBaseComponent
    def all_rows
      summary_rows [organisation_row]
    end

    private

    def organisation_row
      {
        label: "Your organisation",
        value: organisation_address(organisation),
        path: :organisation_address
      }
    end

    def section
      Referrals::Sections::OrganisationSection.new(referral:)
    end
  end
end
