module SupportInterface
  class EligibilityCheckComponent < ViewComponent::Base
    include ActiveModel::Model
    include ReferralHelper

    attr_accessor :referral, :eligibility_check

    def rows
      summary_rows [
                     date_started_row,
                     date_updated_row,
                     reporting_as_row,
                     made_an_informal_complaint_row,
                     teaching_in_england_row,
                     serious_misconduct_row
                   ].compact
    end

    def title
      "Eligibility check ##{eligibility_check.id}"
    end

    private

    def date_started_row
      { label: "Date started", value: eligibility_check.created_at.to_fs(:day_month_year_time) }
    end

    def date_updated_row
      { label: "Date updated", value: eligibility_check.updated_at.to_fs(:day_month_year_time) }
    end

    def reporting_as_row
      {
        label: "Select if you’re making a referral as an employer or member of public",
        value: eligibility_check.reporting_as&.titleize
      }
    end

    def made_an_informal_complaint_row
      return if eligibility_check.reporting_as_employer?

      { label: "Made an informal complaint", value: eligibility_check.complained? ? "Yes" : "No" }
    end

    def teaching_in_england_row
      {
        label:
          "Select yes if they were employed in England at the time the alleged misconduct took place",
        value: eligibility_check.teaching_in_england&.titleize
      }
    end

    def serious_misconduct_row
      {
        label: "Select yes if the allegation involves serious misconduct",
        value: eligibility_check.serious_misconduct&.titleize
      }
    end
  end
end
