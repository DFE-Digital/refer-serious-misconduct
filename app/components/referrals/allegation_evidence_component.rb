module Referrals
  class AllegationEvidenceComponent < ReferralFormBaseComponent
    def all_rows
      summary_rows [anything_to_upload_row, evidence_row].compact
    end

    private

    def anything_to_upload_row
      {
        label: "Do you have anything to upload?",
        visually_hidden_text: "if you have anything to upload",
        value: referral.has_evidence,
        path: :start
      }
    end

    def evidence_row
      return unless referral.has_evidence?

      { label: "Uploaded evidence", value: evidence_text, path: :uploaded }
    end

    def evidence_text
      return "Not answered" if referral.evidence_uploads.empty?

      tag.ul(class: "govuk-list govuk-list--bullet govuk-!-margin-bottom-0") do
        referral.evidence_uploads.map do |evidence_upload|
          concat(
            tag.li(class: "govuk-!-margin-bottom-0") do
              govuk_link_to(
                evidence_upload.filename,
                rails_blob_path(evidence_upload.file, disposition: "attachment")
              )
            end
          )
        end
      end
    end

    def section
      Referrals::Sections::AllegationEvidenceSection.new(referral:)
    end
  end
end
