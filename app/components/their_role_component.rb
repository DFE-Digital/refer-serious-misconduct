class TheirRoleComponent < ViewComponent::Base
  include ActiveModel::Model
  include ReferralHelper

  attr_accessor :referral

  def rows
    [
      {
        actions: [
          {
            text: "Change",
            href:
              referrals_edit_teacher_role_start_date_path(
                referral,
                return_to: request.url
              ),
            visually_hidden_text: "start date"
          }
        ],
        key: {
          text: "Job start date"
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
            href:
              referrals_edit_teacher_employment_status_path(
                referral,
                return_to: request.url
              ),
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
            href:
              referrals_edit_teacher_job_title_path(
                referral,
                return_to: request.url
              ),
            visually_hidden_text: "job title"
          }
        ],
        key: {
          text: "Job title"
        },
        value: {
          text: referral.job_title || "Not known"
        }
      },
      {
        actions: [
          {
            text: "Change",
            href:
              referrals_edit_teacher_same_organisation_path(
                referral,
                return_to: request.url
              ),
            visually_hidden_text: "working in the same organisation"
          }
        ],
        key: {
          text: "Do they work in the same organisation as you?"
        },
        value: {
          text: referral.same_organisation ? "Yes" : "No"
        }
      },
      {
        actions: [
          {
            text: "Change",
            href:
              referrals_edit_teacher_duties_path(
                referral,
                return_to: request.url
              ),
            visually_hidden_text: "main duties"
          }
        ],
        key: {
          text: "About their main duties"
        },
        value: {
          text: duties_details(referral)
        }
      },
      {
        actions: [
          {
            text: "Change",
            href:
              referrals_edit_teacher_role_teaching_somewhere_else_path(
                referral,
                return_to: request.url
              ),
            visually_hidden_text: "teaching somewhere else"
          }
        ],
        key: {
          text: "Do they teach somewhere else?"
        },
        value: {
          text: referral.teaching_somewhere_else&.humanize
        }
      }
    ]
  end
end
