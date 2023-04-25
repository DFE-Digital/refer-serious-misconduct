class TheirRoleComponent < ViewComponent::Base
  include ActiveModel::Model
  include ReferralHelper
  include AddressHelper
  include ComponentHelper

  def rows
    summary_rows [
                   job_title_row,
                   role_duties_row,
                   role_duties_description_row,
                   same_organisation_row,
                   organisation_address_known_row,
                   organisation_address_row,
                   start_date_known_row,
                   start_date_row,
                   employment_status_row,
                   end_date_known_row,
                   end_date_row,
                   reason_leaving_role_row,
                   working_somewhere_else_row,
                   work_location_known_row,
                   work_location_row
                 ].compact
  end

  private

  def job_title_row
    { label: "Their job title", value: referral.job_title, path: :teacher_role_job_title }
  end

  def role_duties_row
    {
      label: "How do you want to give details about their main duties?",
      value: duties_format(referral),
      path: :teacher_role_duties,
      visually_hidden_text: "how you want to give details about their main duties"
    }
  end

  def role_duties_description_row
    {
      label: "Description of their role",
      value: duties_details(referral),
      path: :teacher_role_duties
    }
  end

  def same_organisation_row
    return unless referral.from_employer?

    {
      label:
        "Were they employed at the same organisation as you at the time of the alleged misconduct?",
      value: referral.same_organisation,
      path: :teacher_role_same_organisation,
      visually_hidden_text:
        "if they were employed at the same organisation as you at the time of the alleged misconduct"
    }
  end

  def organisation_address_known_row
    return unless referral.from_employer?
    return if referral.same_organisation.nil? || referral.same_organisation?

    {
      label:
        "Do you know the name and address of the organisation where the alleged misconduct took place?",
      value: referral.organisation_address_known,
      path: :teacher_role_organisation_address_known,
      visually_hidden_text:
        "if you know the name and address of the organisation where the alleged misconduct took place"
    }
  end

  def organisation_address_row
    return unless referral.from_employer?
    return if referral.same_organisation? || !referral.organisation_address_known

    {
      label: "Name and address of the organisation where the alleged misconduct took place",
      value: referral_organisation_address(referral),
      path: :teacher_role_organisation_address
    }
  end

  def start_date_known_row
    return unless referral.from_employer?

    {
      label: "Do you know when they started the job?",
      value: referral.role_start_date_known,
      path: :teacher_role_start_date,
      visually_hidden_text: "if you know when they started the job"
    }
  end

  def start_date_row
    return unless referral.from_employer? && referral.role_start_date_known

    {
      label: "Job start date",
      value: referral.role_start_date&.to_fs(:long_ordinal_uk),
      path: :teacher_role_start_date
    }
  end

  def employment_status_row
    return unless referral.from_employer?

    {
      label: "Are they still employed at the organisation where the alleged misconduct took place?",
      value: employment_status(referral),
      path: :teacher_role_employment_status,
      visually_hidden_text:
        "if are they still employed at the organisation where the alleged misconduct took place"
    }
  end

  def end_date_known_row
    return unless referral.left_role?

    {
      label: "Do you know when they left the job?",
      value: referral.role_end_date_known,
      path: :teacher_role_end_date,
      visually_hidden_text: "if you know when they left the job"
    }
  end

  def end_date_row
    return unless referral.left_role? && referral.role_end_date_known

    {
      label: "Job end date",
      value: referral.role_end_date&.to_fs(:long_ordinal_uk),
      path: :teacher_role_end_date
    }
  end

  def reason_leaving_role_row
    return unless referral.left_role?

    {
      label: "Reason they left the job",
      value: reason_leaving_role,
      path: :teacher_role_reason_leaving_role
    }
  end

  def working_somewhere_else_row
    return unless referral.left_role?

    {
      label: "Are they employed somewhere else?",
      value: working_somewhere_else,
      path: :teacher_role_working_somewhere_else,
      visually_hidden_text: "if they are they employed somewhere else"
    }
  end

  def work_location_known_row
    return unless referral.left_role? && referral.working_somewhere_else?

    {
      label: "Do you know the name and address of the organisation where they’re employed?",
      value: referral.work_location_known,
      path: :teacher_role_work_location_known,
      visually_hidden_text:
        "if you know the name and address of the organisation where they’re employed"
    }
  end

  def work_location_row
    return unless referral.left_role? && referral.work_location_known?

    {
      label: "Name and address of the organisation where they’re employed",
      value: teaching_address(referral).presence,
      path: :teacher_role_work_location
    }
  end

  def reason_leaving_role
    return "I'm not sure" if referral.reason_leaving_role&.to_sym == :unknown

    referral.reason_leaving_role&.humanize.presence || "Not answered"
  end

  def working_somewhere_else
    return "I'm not sure" if referral.working_somewhere_else&.to_sym == :not_sure

    referral.working_somewhere_else&.humanize.presence || "Not answered"
  end

  def section
    Referrals::Sections::TeacherRoleSection.new(referral:)
  end
end
