class TheirRoleComponent < ViewComponent::Base
  include ActiveModel::Model

  attr_accessor :referral

  def rows
    [
      {
        actions: [
          {
            text: "Change",
            href: referrals_edit_teacher_role_start_date_path(referral),
            visually_hidden_text: "start date"
          }
        ],
        key: {
          text: "Start date"
        },
        value: {
          text:
            (
              if referral.role_start_date_known
                referral.role_start_date&.to_fs(:long_ordinal_uk)
              else
                "Not known"
              end
            )
        }
      },
      {
        actions: [
          {
            text: "Change",
            href: referrals_edit_teacher_employment_status_path(referral),
            visually_hidden_text: "employment status"
          }
        ],
        key: {
          text: "Are they still employed in that job?"
        },
        value: {
          text:
            (
              if referral.employment_status
                referral.employment_status.humanize
              else
                "Not known"
              end
            )
        }
      },
      {
        actions: [
          {
            text: "Change",
            href: referrals_edit_teacher_job_title_path(referral),
            visually_hidden_text: "job title"
          }
        ],
        key: {
          text: "Job title"
        },
        value: {
          text: referral.job_title || "Not known"
        }
      }
    ]
  end
end
