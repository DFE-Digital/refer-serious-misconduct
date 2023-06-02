module Referrals
  module Sections
    class AllegationEvidenceSection < Section
      def items
        [
          Referrals::AllegationEvidence::StartForm.new(referral:),
          referral.evidence_uploads.none? && referral.has_evidence? &&
            Referrals::AllegationEvidence::UploadForm.new(referral:),
          referral.has_evidence && Referrals::AllegationEvidence::UploadedForm.new(referral:),
          Referrals::AllegationEvidence::CheckAnswersForm.new(referral:)
        ].compact_blank
      end

      def complete?
        referral.evidence_details_complete
      end

      def view_component(**args)
        AllegationEvidenceComponent.new(referral:, **args)
      end
    end
  end
end
