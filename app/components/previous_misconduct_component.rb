class PreviousMisconductComponent < ViewComponent::Base
  include ActiveModel::Model
  include ApplicationHelper
  include ComponentHelper
  include ReferralHelper

  attr_accessor :referral

  def rows
    items = [
      {
        actions: [
          {
            text: "Change",
            href: [:edit, referral.routing_scope, referral, :previous_misconduct, :reported, { return_to: }],
            visually_hidden_text: "if there has been any previous misconduct"
          }
        ],
        key: {
          text: "Has there been any previous misconduct?"
        },
        value: {
          text: nullable_value_to_s(humanize_three_way_choice(referral.previous_misconduct_reported))
        }
      }
    ]
    if referral.previous_misconduct_reported?
      items << {
        actions: [
          {
            text: "Change",
            href: [:edit, referral.routing_scope, referral, :previous_misconduct, :detailed_account, { return_to: }],
            visually_hidden_text: "how you want to give details about previous allegations"
          }
        ],
        key: {
          text: "How do you want to give details about previous allegations?"
        },
        value: {
          text: detail_type
        }
      }
      items << {
        actions: [
          {
            text: "Change",
            href: [:edit, referral.routing_scope, referral, :previous_misconduct, :detailed_account, { return_to: }],
            visually_hidden_text: "detailed account"
          }
        ],
        key: {
          text: "Detailed account"
        },
        value: {
          text: report
        }
      }
    end

    referral.submitted? ? remove_actions(items) : items
  end

  def report
    if referral.previous_misconduct_upload.attached?
      return(
        govuk_link_to(
          referral.previous_misconduct_upload.filename,
          rails_blob_path(referral.previous_misconduct_upload, disposition: "attachment")
        )
      )
    end

    return simple_format(referral.previous_misconduct_details) if referral.previous_misconduct_details.present?

    "Not answered"
  end

  def return_to
    polymorphic_path([:edit, referral.routing_scope, referral, :previous_misconduct_check_answers])
  end

  def detail_type
    case referral.previous_misconduct_format
    when "details"
      referral.previous_misconduct_details.present? ? "Describe the allegation" : "Incomplete"
    when "upload"
      referral.previous_misconduct_upload.attached? ? "Upload file" : "Incomplete"
    else
      "Not answered"
    end
  end
end
