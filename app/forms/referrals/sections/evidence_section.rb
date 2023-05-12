module Referrals
  module Sections
    class EvidenceSection < Section
      def items
        [
          Referrals::Evidence::StartForm.new(referral:),
          referral.evidences.none? && referral.has_evidence? &&
            Referrals::Evidence::UploadForm.new(referral:),
          referral.has_evidence && Referrals::Evidence::UploadedForm.new(referral:),
          Referrals::Evidence::CheckAnswersForm.new(referral:)
        ].compact_blank
      end

      def slug
        "evidence"
      end

      def complete?
        referral.evidence_details_complete
      end

      def label
        I18n.t("referral_form.evidence_and_supporting_information")
      end

      def view_component(**args)
        EvidenceComponent.new(referral:, **args)
      end
    end
  end
end
