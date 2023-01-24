module ManageInterface
  class EmploymentDetailsComponent < ViewComponent::Base
    include ActiveModel::Model
    include ReferralHelper
    include AddressHelper

    attr_accessor :referral

    def rows
      rows = [
        {
          key: {
            text: "Job title"
          },
          value: {
            text: referral.job_title || "Not known"
          }
        },
        {
          key: {
            text: "Main duties"
          },
          value: {
            text: duties_details(referral)
          }
        }
      ]

      return rows unless referral.from_employer?

      rows.push(organisation_row)
      if referral.role_start_date_known
        rows.push(
          {
            key: {
              text: "Job start date"
            },
            value: {
              text: referral.role_start_date&.to_fs(:long_ordinal_uk)
            }
          }
        )
      end
      if referral.role_end_date_known
        rows.push(
          {
            key: {
              text: "Job end date"
            },
            value: {
              text: referral.role_end_date&.to_fs(:long_ordinal_uk)
            }
          }
        )
      end
      rows.push(
        {
          key: {
            text: "Reason they left the job"
          },
          value: {
            text: referral.reason_leaving_role&.humanize
          }
        }
      )

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
  end
end
