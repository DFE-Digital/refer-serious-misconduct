module ManageInterface
  class AllegationPreviousMisconductComponent < ViewComponent::Base
    include ActiveModel::Model
    include ReferralHelper
    include ApplicationHelper

    attr_accessor :referral

    def rows
      summary_rows [
                     any_previous_misconduct_row,
                     details_type_previous_allegation_row,
                     details_previous_allegation_row
                   ].compact
    end

    def title
      "Previous allegation details"
    end

    private

    def details_type_previous_allegation_row
      { label: "How do you want to give details about previous allegations?", value: detail_type }
    end

    def details_previous_allegation_row
      { label: "Previous allegation details", value: previous_allegation_details(referral) }
    end

    def any_previous_misconduct_row
      return if referral.previous_misconduct_reported?

      {
        label: "Has there been any previous misconduct?",
        value: humanize_three_way_choice(referral.previous_misconduct_reported)
      }
    end

    def detail_type
      return "Upload file" if referral.previous_misconduct_upload_file

      "Describe the allegation"
    end
  end
end
