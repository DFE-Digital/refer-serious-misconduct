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
  end
end
