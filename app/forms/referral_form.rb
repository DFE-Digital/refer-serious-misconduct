class ReferralForm
  include Rails.application.routes.url_helpers
  include ActiveModel::Model
  include ReferralHelper

  attr_accessor :referral

  # TODO: Replace these with something reading from :referral model fields
  ReferralSection = Struct.new(:number, :label, :items)
  ReferralSectionItem = Struct.new(:label, :path, :status)

  validate :sections_valid

  def save
    valid?
  end

  def sections
    [
      about_you_section,
      about_the_person_you_are_referring_section,
      the_allegation_section
    ]
  end

  private

  def sections_valid
    unless sections.map(&:items).flatten.map(&:status).uniq == [:completed]
      errors.add(:base, "Please complete all sections of the referral")
    end
  end

  def about_you_section
    ReferralSection
      .new(1, I18n.t("referral_form.about_you"))
      .tap do |section|
        section.items = [
          ReferralSectionItem.new(
            I18n.t("referral_form.your_details"),
            subsection_path(
              action: :edit,
              referral:,
              subsection: :referrer_name
            ),
            referral.referrer_status
          )
        ]

        if referral.from_employer?
          section.items.append(
            ReferralSectionItem.new(
              I18n.t("referral_form.your_organisation"),
              edit_referral_organisation_name_path(referral),
              referral.organisation_status
            )
          )
        end
      end
  end

  def about_the_person_you_are_referring_section
    ReferralSection
      .new(2, I18n.t("referral_form.about_the_person_you_are_referring"))
      .tap do |section|
        section.items = [
          ReferralSectionItem.new(
            I18n.t("referral_form.personal_details"),
            subsection_path(
              referral:,
              subsection: :personal_details_name,
              action: :edit
            ),
            section_status(:personal_details_complete)
          )
        ]

        if referral.from_employer?
          section.items.append(
            ReferralSectionItem.new(
              I18n.t("referral_form.contact_details"),
              edit_referral_contact_details_email_path(referral),
              section_status(:contact_details_complete)
            )
          )
        end

        section.items.append(
          ReferralSectionItem.new(
            I18n.t("referral_form.about_their_role"),
            edit_referral_teacher_role_job_title_path(referral),
            section_status(:teacher_role_complete)
          )
        )
      end
  end

  def the_allegation_section
    ReferralSection
      .new(3, I18n.t("referral_form.the_allegation"))
      .tap do |section|
        section.items = [
          ReferralSectionItem.new(
            I18n.t("referral_form.details_of_the_allegation"),
            edit_referral_allegation_details_path(referral),
            section_status(:allegation_details_complete)
          )
        ]

        if referral.from_employer?
          section.items.append(
            ReferralSectionItem.new(
              I18n.t("referral_form.previous_allegations"),
              edit_referral_previous_misconduct_reported_path(referral),
              referral.previous_misconduct_status
            )
          )
        end

        section.items.append(
          ReferralSectionItem.new(
            I18n.t("referral_form.evidence_and_supporting_information"),
            path_for_section_status(
              section_status(:evidence_details_complete),
              subsection_path(
                referral:,
                action: :edit,
                subsection: :evidence_start
              ),
              subsection_path(
                referral:,
                action: :edit,
                subsection: :evidence_check_answers
              )
            ),
            section_status(:evidence_details_complete)
          )
        )
      end
  end

  def section_status(section_complete_method)
    status = referral.send(section_complete_method)
    return :not_started_yet if status.nil?

    status ? :completed : :incomplete
  end

  def path_for_section_status(status, start_path, check_answers_path)
    return start_path if status == :not_started_yet

    check_answers_path
  end
end
