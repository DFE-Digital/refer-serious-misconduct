module ManageInterface
  class PreviousAllegationDetailsComponent < ViewComponent::Base
    include ActiveModel::Model
    include ReferralHelper
    include ApplicationHelper

    attr_accessor :referral

    def rows
      [
        {
          key: {
            text: "Has there been any previous misconduct?"
          },
          value: {
            text:
              humanize_three_way_choice(referral.previous_misconduct_reported)
          }
        },
        {
          key: {
            text: "How do you want to give details about previous allegations?"
          },
          value: {
            text: detail_type
          }
        },
        {
          key: {
            text: "Previous allegation details"
          },
          value: {
            text: previous_allegation_details(referral)
          }
        }
      ]
    end

    def title
      "Previous allegation details"
    end

    def detail_type
      return "Upload file" if referral.previous_misconduct_upload.attached?

      "Describe the allegation"
    end
  end
end
