module ManageInterface
  class EmploymentDetailsComponent < ViewComponent::Base
    include ActiveModel::Model
    include ReferralHelper
    include AddressHelper

    attr_accessor :referral

    def rows
      rows = [
        { key: { text: "Job title" }, value: { text: referral.job_title || "Not known" } },
        { key: { text: "How where details about their main duties given?" }, value: { text: duties_format(referral) } },
        { key: { text: "Main duties" }, value: { text: duties_details(referral) } }
      ]

      if referral.from_member_of_public?
        if !referral.organisation_address_known
          rows.push(
            {
              key: {
                text: "Do you know the name and address of the organisation where the alleged misconduct took place?"
              },
              value: {
                text: "No"
              }
            }
          )
        else
          rows.push(
            {
              key: {
                text: "Name and address of the organisation where the alleged misconduct took place"
              },
              value: {
                text: referral_organisation_address(referral)
              }
            }
          )
        end
      end

      return rows unless referral.from_employer?

      if !referral.same_organisation
        rows.push(
          {
            key: {
              text: "Were they employed at the same organisation as you at the time of the alleged misconduct?"
            },
            value: {
              text: "No"
            }
          }
        )
      else
        rows.push(organisation_row)
      end

      if !referral.role_start_date_known
        rows.push({ key: { text: "Do you know when they started the job?" }, value: { text: "No" } })
      else
        rows.push(
          { key: { text: "Job start date" }, value: { text: referral.role_start_date&.to_fs(:long_ordinal_uk) } }
        )
      end

      if employment_status(referral) == "No"
        rows.push(
          {
            key: {
              text: "Are they still employed at the organisation where the alleged misconduct took place?"
            },
            value: {
              text: "No"
            }
          }
        )

        if !referral.role_end_date_known
          rows.push({ key: { text: "Do you know when they left the job?" }, value: { text: "No" } })
        else
          rows.push({ key: { text: "Job end date" }, value: { text: referral.role_end_date&.to_fs(:long_ordinal_uk) } })
        end

        rows.push(
          { key: { text: "Reason they left the job" }, value: { text: referral.reason_leaving_role&.humanize } }
        )

        if working_somewhere_else != "Yes"
          rows.push({ key: { text: "Are they employed somewhere else?" }, value: { text: working_somewhere_else } })
        elsif !referral.work_location_known
          rows.push(
            {
              key: {
                text: "Do you know the name and address of the organisation where they’re employed?"
              },
              value: {
                text: "No"
              }
            }
          )
        end
      end

      rows
    end

    def title
      "Employment details"
    end

    private

    def organisation_row
      {
        key: {
          text: "Organisation"
        },
        value: {
          text:
            (
              if referral.same_organisation?
                organisation_address(referral.organisation)
              else
                referral_organisation_address(referral)
              end
            )
        }
      }
    end

    def working_somewhere_else
      return "I'm not sure" if referral.working_somewhere_else.to_sym == :not_sure

      referral.working_somewhere_else&.humanize
    end
  end
end
