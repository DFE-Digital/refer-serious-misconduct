class PreviousMisconductComponent < ViewComponent::Base
  include ActiveModel::Model
  include ApplicationHelper

  attr_accessor :referral

  def rows
    @rows = [
      {
        actions: [
          {
            text: "Change",
            href: [
              :edit,
              referral.routing_scope,
              referral,
              :previous_misconduct,
              :reported,
              { return_to: }
            ],
            visually_hidden_text: "if there has been any previous misconduct"
          }
        ],
        key: {
          text: "Has there been any previous misconduct?"
        },
        value: {
          text: humanize_three_way_choice(referral.previous_misconduct_reported)
        }
      }
    ]
    if referral.previous_misconduct_reported?
      @rows << {
        actions: [
          {
            text: "Change",
            href: [
              :edit,
              referral.routing_scope,
              referral,
              :previous_misconduct,
              :detailed_account,
              { return_to: }
            ],
            visually_hidden_text:
              "how you want to give details about previous allegations"
          }
        ],
        key: {
          text: "How do you want to give details about previous allegations?"
        },
        value: {
          text: detail_type
        }
      }
      @rows << {
        actions: [
          {
            text: "Change",
            href: [
              :edit,
              referral.routing_scope,
              referral,
              :previous_misconduct,
              :detailed_account,
              { return_to: }
            ],
            visually_hidden_text: "details"
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

    @rows
  end

  def report
    if referral.previous_misconduct_upload.attached?
      return(
        govuk_link_to(
          referral.previous_misconduct_upload.filename,
          rails_blob_path(
            referral.previous_misconduct_upload,
            disposition: "attachment"
          )
        )
      )
    end

    if referral.previous_misconduct_details.present?
      return simple_format(referral.previous_misconduct_details)
    end

    "Not answered yet"
  end

  def return_to
    polymorphic_path(
      [
        :edit,
        referral.routing_scope,
        referral,
        :previous_misconduct_check_answers
      ]
    )
  end

  def detail_type
    return "Upload file" if referral.previous_misconduct_upload.attached?

    "Describe the allegation"
  end
end
