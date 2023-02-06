class TheirRoleComponent < ViewComponent::Base
  include ActiveModel::Model
  include ReferralHelper
  include AddressHelper

  attr_accessor :referral

  def rows
    @rows = [job_title_row, role_duties_row, role_duties_description_row]

    @rows << same_organisation_row if referral.from_employer?

    unless referral.same_organisation?
      @rows << organisation_address_known_row
      @rows << organisation_address_row if referral.organisation_address_known
    end

    @rows << start_date_known_row if referral.from_employer?
    @rows << start_date_row if referral.role_start_date_known
    @rows << employment_status_row if referral.from_employer?

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
          href: path_for(:job_title),
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
          href: path_for(:duties),
          visually_hidden_text:
            "how you want to give details about their main duties"
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
          href: path_for(:duties),
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
          href: path_for(:same_organisation),
          visually_hidden_text:
            "if they were employed at the same organisation as you at the time of the alleged misconduct"
        }
      ],
      key: {
        text:
          "Were they employed at the same organisation as you at the time of the alleged misconduct?"
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
          href: path_for(:organisation_address_known),
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
          href: path_for(:organisation_address),
          visually_hidden_text:
            "name and address of the organisation where the alleged misconduct took place"
        }
      ],
      key: {
        text:
          "Name and address of the organisation where the alleged misconduct took place"
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
          href: path_for(:start_date),
          visually_hidden_text: "if you know when they started the job"
        }
      ],
      key: {
        text: "Do you know when they started the job?"
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
          href: path_for(:start_date),
          visually_hidden_text: "the job start date"
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
          href: path_for(:employment_status),
          visually_hidden_text:
            "if are they still employed at the organisation where the alleged misconduct took place?"
        }
      ],
      key: {
        text:
          "Are they still employed at the organisation where the alleged misconduct took place?"
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
          href: path_for(:end_date),
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
          href: path_for(:end_date),
          visually_hidden_text: "the job end date"
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
          href: path_for(:reason_leaving_role),
          visually_hidden_text: "the reason they left the job"
        }
      ],
      key: {
        text: "Reason they left the job"
      },
      value: {
        text: reason_leaving_role
      }
    }
  end

  def working_somewhere_else_row
    {
      actions: [
        {
          text: "Change",
          href: path_for(:working_somewhere_else),
          visually_hidden_text: "if they are they employed somewhere else"
        }
      ],
      key: {
        text: "Are they employed somewhere else?"
      },
      value: {
        text: working_somewhere_else
      }
    }
  end

  def work_location_known_row
    {
      actions: [
        {
          text: "Change",
          href: path_for(:work_location_known),
          visually_hidden_text:
            "if you know the name and address of the organisation where they’re employed"
        }
      ],
      key: {
        text:
          "Do you know the name and address of the organisation where they’re employed?"
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
          href: path_for(:work_location),
          visually_hidden_text:
            "name and address of the organisation where they’re employed"
        }
      ],
      key: {
        text: "Name and address of the organisation where they’re employed"
      },
      value: {
        text: teaching_address(referral)
      }
    }
  end

  def path_for(part)
    [
      :edit,
      referral.routing_scope,
      referral,
      :teacher_role,
      part,
      { return_to: }
    ]
  end

  def return_to
    polymorphic_path(
      [:edit, referral.routing_scope, referral, :teacher_role, :check_answers]
    )
  end

  def reason_leaving_role
    return "I'm not sure" if referral.reason_leaving_role.to_sym == :unknown

    referral.reason_leaving_role&.humanize
  end

  def working_somewhere_else
    return "I'm not sure" if referral.working_somewhere_else.to_sym == :not_sure

    referral.working_somewhere_else&.humanize
  end
end
