class EvidenceComponent < ViewComponent::Base
  include ActiveModel::Model

  attr_accessor :referral

  def rows
    [anything_to_upload_row, evidence_row].compact
  end

  private

  def anything_to_upload_row
    {
      actions: [
        {
          text: "Change",
          href:
            edit_referral_evidence_start_path(referral, return_to: request.url)
        }
      ],
      key: {
        text: "Do you have anything to upload?"
      },
      value: {
        text: referral.has_evidence ? "Yes" : "No"
      }
    }
  end

  def evidence_row
    return unless referral.evidences.any?

    {
      actions: [
        {
          text: "Change",
          href:
            edit_referral_evidence_uploaded_path(
              referral,
              return_to: request.url
            )
        }
      ],
      key: {
        text: "Uploaded evidence"
      },
      value: {
        text: evidence_text
      }
    }
  end

  def evidence_text
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
end
