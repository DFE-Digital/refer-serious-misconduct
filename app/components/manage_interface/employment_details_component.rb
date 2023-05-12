module ManageInterface
  class EmploymentDetailsComponent < ViewComponent::Base
    include ActiveModel::Model
    include ReferralHelper
    include AddressHelper

    attr_accessor :referral

    def rows
      summary_rows [
                     job_title_row,
                     details_about_main_duties_row,
                     main_duties_row,
                     organisation_address_where_misconduct_occurred_row,
                     organisation_address_where_employed_row,
                     role_start_date_row,
                     employment_status_row
                   ].flatten.compact
    end

    def title
      "Employment details"
    end

    private

    def job_title_row
      { label: "Job title", value: referral.job_title }
    end

    def details_about_main_duties_row
      { label: "How were details about their main duties given?", value: duties_format(referral) }
    end

    def main_duties_row
      { label: "Main duties", value: duties_details(referral) }
    end

    def organisation_address_where_misconduct_occurred_row
      if referral.organisation_address_known
        {
          label: "Name and address of the organisation where the alleged misconduct took place",
          value: referral_organisation_address(referral)
        }
      else
        {
          label:
            "Do you know the name and address of the organisation where the alleged misconduct took place?",
          value: "No"
        }
      end
    end

    def organisation_address_where_employed_row
      return unless referral.from_employer?

      if referral.same_organisation?
        { label: "Organisation", value: organisation_address(referral.organisation) }
      else
        {
          label:
            "Were they employed at the same organisation as you at the time of the alleged misconduct?",
          value: "No"
        }
      end
    end

    def role_start_date_row
      return unless referral.from_employer?

      if referral.role_start_date_known
        { label: "Job start date", value: referral.role_start_date&.to_fs(:long_ordinal_uk) }
      else
        { label: "Do you know when they started the job?", value: "No" }
      end
    end

    def employment_status_row
      return unless referral.from_employer?
      return if employment_status(referral) != "No"

      [
        not_employed_anymore_row,
        role_end_date_row,
        reason_for_leaving_row,
        working_somewhere_else_row
      ]
    end

    def not_employed_anymore_row
      {
        label:
          "Are they still employed at the organisation where the alleged misconduct took place?",
        value: "No"
      }
    end

    def role_end_date_row
      if referral.role_end_date_known
        { label: "Job end date", value: referral.role_end_date&.to_fs(:long_ordinal_uk) }
      else
        { label: "Do you know when they left the job?", value: "No" }
      end
    end

    def reason_for_leaving_row
      { label: "Reason they left the job", value: referral.reason_leaving_role&.humanize }
    end

    def working_somewhere_else_row
      if working_somewhere_else != "Yes"
        { label: "Are they employed somewhere else?", value: working_somewhere_else }
      elsif !referral.work_location_known
        {
          label: "Do you know the name and address of the organisation where they’re employed?",
          value: "No"
        }
      end
    end

    def working_somewhere_else
      return "I'm not sure" if referral.working_somewhere_else.to_sym == :not_sure

      referral.working_somewhere_else&.humanize
    end
  end
end
