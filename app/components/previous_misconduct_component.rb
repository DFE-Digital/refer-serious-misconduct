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
            href:
              edit_referral_previous_misconduct_reported_path(
                referral,
                return_to: request.url
              ),
            visually_hidden_text: "reported"
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
            href:
              edit_referral_previous_misconduct_detailed_account_path(
                referral,
                return_to: request.url
              ),
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
      return referral.previous_misconduct_upload.filename
    end

    if referral.previous_misconduct_details.present?
      return simple_format(referral.previous_misconduct_details)
    end

    "Not answered yet"
  end
end
