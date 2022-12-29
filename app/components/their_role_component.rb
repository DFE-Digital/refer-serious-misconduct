class TheirRoleComponent < ViewComponent::Base
  include ActiveModel::Model
  include ReferralHelper
  include AddressHelper

  attr_accessor :referral

  def rows
    @rows = [
      job_title_row,
      role_duties_row,
      role_duties_description_row,
      same_organisation_row
    ]

    unless referral.same_organisation?
      @rows << organisation_address_known_row
      @rows << organisation_address_row
    end

    @rows << start_date_known_row
    @rows << start_date_row if referral.role_start_date_known
    @rows << employment_status_row

    return @rows unless referral.left_role?

    @rows << end_date_known_row
    @rows << end_date_row if referral.role_end_date_known
    @rows << reason_leaving_role_row
    @rows << working_somewhere_else_row

    return @rows unless referral.working_somewhere_else?

    @rows << work_location_known_row

    return @rows unless referral.work_location_known

    @rows << work_location_row
  end

  private

  def job_title_row
    {
      actions: [
        {
          text: "Change",
          href:
            edit_referral_teacher_role_job_title_path(
              referral,
              return_to: request.url
            ),
          visually_hidden_text: "their job title"
        }
      ],
      key: {
        text: "Their job title"
      },
      value: {
        text: referral.job_title || "Not known"
      }
    }
  end

  def role_duties_row
    {
      actions: [
        {
          text: "Change",
          href:
            edit_referral_teacher_role_duties_path(
              referral,
              return_to: request.url
            ),
          visually_hidden_text:
            "how do you want to give details about their main duties"
        }
      ],
      key: {
        text: "How do you want to give details about their main duties?"
      },
      value: {
        text: duties_format(referral)
      }
    }
  end

  def role_duties_description_row
    {
      actions: [
        {
          text: "Change",
          href:
            edit_referral_teacher_role_duties_path(
              referral,
              return_to: request.url
            ),
          visually_hidden_text: "the description of their role"
        }
      ],
      key: {
        text: "Description of their role"
      },
      value: {
        text: duties_details(referral)
      }
    }
  end

  def same_organisation_row
    {
      actions: [
        {
          text: "Change",
          href:
            edit_referral_teacher_role_same_organisation_path(
              referral,
              return_to: request.url
            ),
          visually_hidden_text: "working in the same organisation"
        }
      ],
      key: {
        text:
          "Did they work at the same organisation as you at the time of the alleged misconduct?"
      },
      value: {
        text: referral.same_organisation ? "Yes" : "No"
      }
    }
  end

  def organisation_address_known_row
    {
      actions: [
        {
          text: "Change",
          href:
            edit_referral_teacher_role_organisation_address_known_path(
              referral,
              return_to: request.url
            ),
          visually_hidden_text:
            "if you know the name and address of the organisation where the alleged misconduct took place"
        }
      ],
      key: {
        text:
          "Do you know the name and address of the organisation where the alleged misconduct took place?"
      },
      value: {
        text: referral.organisation_address_known ? "Yes" : "No"
      }
    }
  end

  def organisation_address_row
    {
      actions: [
        {
          text: "Change",
          href:
            edit_referral_teacher_role_organisation_address_path(
              referral,
              return_to: request.url
            ),
          visually_hidden_text:
            "where they were employed at the time of the alleged misconduct"
        }
      ],
      key: {
        text: "Where they were employed at the time of the alleged misconduct"
      },
      value: {
        text: referral_organisation_address(referral)
      }
    }
  end

  def start_date_known_row
    {
      actions: [
        {
          text: "Change",
          href:
            edit_referral_teacher_role_start_date_path(
              referral,
              return_to: request.url
            ),
          visually_hidden_text: "if you know when they started their job"
        }
      ],
      key: {
        text: "Do you know when they started their job?"
      },
      value: {
        text: referral.role_start_date_known ? "Yes" : "No"
      }
    }
  end

  def start_date_row
    {
      actions: [
        {
          text: "Change",
          href:
            edit_referral_teacher_role_start_date_path(
              referral,
              return_to: request.url
            ),
          visually_hidden_text: "their job start date"
        }
      ],
      key: {
        text: "Job start date"
      },
      value: {
        text: referral.role_start_date&.to_fs(:long_ordinal_uk)
      }
    }
  end

  def employment_status_row
    {
      actions: [
        {
          text: "Change",
          href:
            edit_referral_teacher_role_employment_status_path(
              referral,
              return_to: request.url
            ),
          visually_hidden_text:
            "if they are still employed in the job where the alleged misconduct took place"
        }
      ],
      key: {
        text:
          "Are they still employed in the job where the alleged misconduct took place?"
      },
      value: {
        text: employment_status(referral)
      }
    }
  end

  def end_date_known_row
    {
      actions: [
        {
          text: "Change",
          href:
            edit_referral_teacher_role_end_date_path(
              referral,
              return_to: request.url
            ),
          visually_hidden_text: "if you know when they left the job"
        }
      ],
      key: {
        text: "Do you know when they left the job?"
      },
      value: {
        text: referral.role_end_date_known ? "Yes" : "No"
      }
    }
  end

  def end_date_row
    {
      actions: [
        {
          text: "Change",
          href:
            edit_referral_teacher_role_end_date_path(
              referral,
              return_to: request.url
            ),
          visually_hidden_text: "their job end date"
        }
      ],
      key: {
        text: "Job end date"
      },
      value: {
        text: referral.role_end_date&.to_fs(:long_ordinal_uk)
      }
    }
  end

  def reason_leaving_role_row
    {
      actions: [
        {
          text: "Change",
          href:
            edit_referral_teacher_role_reason_leaving_role_path(
              referral,
              return_to: request.url
            ),
          visually_hidden_text: "the reason they left the job"
        }
      ],
      key: {
        text: "Reason they left the job"
      },
      value: {
        text: referral.reason_leaving_role&.humanize
      }
    }
  end

  def working_somewhere_else_row
    {
      actions: [
        {
          text: "Change",
          href:
            edit_referral_teacher_role_working_somewhere_else_path(
              referral,
              return_to: request.url
            ),
          visually_hidden_text: "if they are they employed somewhere else"
        }
      ],
      key: {
        text: "Are they employed somewhere else?"
      },
      value: {
        text: referral.working_somewhere_else&.humanize
      }
    }
  end

  def work_location_known_row
    {
      actions: [
        {
          text: "Change",
          href:
            edit_referral_teacher_role_work_location_known_path(
              referral,
              return_to: request.url
            ),
          visually_hidden_text:
            "if you know the name and address of the organisation where they’re currently working"
        }
      ],
      key: {
        text:
          "Do you know the name and address of the organisation where they’re currently working?"
      },
      value: {
        text: referral.work_location_known ? "Yes" : "No"
      }
    }
  end

  def work_location_row
    {
      actions: [
        {
          text: "Change",
          href:
            edit_referral_teacher_role_work_location_path(
              referral,
              return_to: request.url
            ),
          visually_hidden_text: "where they currently work"
        }
      ],
      key: {
        text: "Where they currently work"
      },
      value: {
        text: teaching_address(referral)
      }
    }
  end
end
