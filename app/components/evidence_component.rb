class EvidenceComponent < ViewComponent::Base
  include ActiveModel::Model
  include ReferralHelper
  include ComponentHelper

  attr_accessor :referral

  def rows
    items = [anything_to_upload_row, evidence_row].compact
    referral.submitted? ? remove_actions(items) : items
  end

  private

  def anything_to_upload_row
    {
      actions: [
        {
          text: "Change",
          href: polymorphic_path([:edit, referral.routing_scope, referral, :evidence_start], return_to: return_to_path),
          visually_hidden_text: "if you have anything to upload"
        }
      ],
      key: {
        text: "Do you have anything to upload?"
      },
      value: {
        text: nullable_boolean_to_s(referral.has_evidence)
      }
    }
  end

  def evidence_row
    return unless referral.has_evidence?

    {
      actions: [
        {
          text: "Change",
          href:
            polymorphic_path([:edit, referral.routing_scope, referral, :evidence_uploaded], return_to: return_to_path),
          visually_hidden_text: "uploaded evidence"
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
    return "Not answered" if referral.evidences.empty?

    tag.ul(class: "govuk-list govuk-list--bullet govuk-!-margin-bottom-0") do
      referral.evidences.map do |evidence|
        concat(
          tag.li(class: "govuk-!-margin-bottom-0") do
            govuk_link_to(evidence.filename, rails_blob_path(evidence.document, disposition: "attachment"))
          end
        )
      end
    end
  end
end
