class EvidenceComponent < ViewComponent::Base
  include ActiveModel::Model
  include ReferralHelper
  include ComponentHelper

  def all_rows
    summary_rows [anything_to_upload_row, evidence_row].compact
  end

  private

  def anything_to_upload_row
    {
      label: "Do you have anything to upload?",
      visually_hidden_text: "if you have anything to upload",
      value: referral.has_evidence,
      path: :evidence_start
    }
  end

  def evidence_row
    return unless referral.has_evidence?

    { label: "Uploaded evidence", value: evidence_text, path: :evidence_uploaded }
  end

  def evidence_text
    return "Not answered" if referral.evidences.empty?

    tag.ul(class: "govuk-list govuk-list--bullet govuk-!-margin-bottom-0") do
      referral.evidences.map do |evidence|
        concat(
          tag.li(class: "govuk-!-margin-bottom-0") do
            govuk_link_to(
              evidence.filename,
              rails_blob_path(evidence.document, disposition: "attachment")
            )
          end
        )
      end
    end
  end

  def section
    Referrals::Sections::EvidenceSection.new(referral:)
  end
end
