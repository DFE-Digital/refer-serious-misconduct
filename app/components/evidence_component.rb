class EvidenceComponent < ViewComponent::Base
  include ActiveModel::Model

  attr_accessor :referral

  def rows
    return evidence_rows if referral.evidences.any?

    [
      {
        actions: [
          {
            text: "Change",
            href: edit_referral_evidence_start_path(referral),
            visually_hidden_text: "evidence"
          }
        ],
        key: {
          text: "Documents"
        },
        value: {
          text: "No evidence uploaded"
        }
      }
    ]
  end

  private

  def evidence_rows
    referral.evidences.map do |evidence|
      {
        actions: [
          {
            text: "Change",
            href:
              edit_referral_evidence_categories_path(
                referral,
                evidence,
                return_to: request.url
              ),
            visually_hidden_text: "categories"
          },
          {
            text: "Delete",
            href:
              referrals_delete_evidence_path(
                referral,
                evidence,
                return_to: request.url
              ),
            visually_hidden_text: "evidence upload"
          }
        ],
        key: {
          text:
            govuk_link_to(
              evidence.filename,
              rails_blob_path(evidence.document, disposition: "attachment")
            )
        },
        value: {
          text:
            Referrals::Evidence::CategoriesForm.selected_categories(
              evidence
            ).join(", ")
        }
      }
    end
  end
end
