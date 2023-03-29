module Referrals
  module SectionGroups
    class AboutYouSectionGroup < SectionGroup
      def items
        [
          Sections::ReferrerSection.new(referral:)
          # referral.from_employer? && Sections::AboutYouSection::OrganisationSection.new(referral:)
        ].compact
      end
    end
  end
end
