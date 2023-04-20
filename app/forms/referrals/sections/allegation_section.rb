module Referrals
  module Sections
    class AllegationSection < Section
      def items
        [
          Referrals::Allegation::DetailsForm.new(referral:),
          referral.from_member_of_public? &&
            Referrals::Allegation::ConsiderationsForm.new(referral:),
          referral.from_employer? && Referrals::Allegation::DbsForm.new(referral:),
          Referrals::Allegation::CheckAnswersForm.new(referral:)
        ].compact_blank
      end

      def slug
        "allegation"
      end

      def complete?
        referral.allegation_details_complete
      end

      def label
        I18n.t("referral_form.details_of_the_allegation")
      end
    end
  end
end
