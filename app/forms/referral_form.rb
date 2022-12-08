class ReferralForm
  include Rails.application.routes.url_helpers
  include ActiveModel::Model

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
    ReferralSection.new(
      1,
      I18n.t("referral_form.about_you"),
      [
        ReferralSectionItem.new(
          I18n.t("referral_form.your_details"),
          edit_referral_referrer_name_path(referral),
          referral.referrer_status
        ),
        ReferralSectionItem.new(
          I18n.t("referral_form.your_organisation"),
          edit_referral_organisation_name_path(referral),
          referral.organisation_status
        )
      ]
    )
  end

  def about_the_person_you_are_referring_section
    ReferralSection.new(
      2,
      I18n.t("referral_form.about_the_person_you_are_referring"),
      [
        ReferralSectionItem.new(
          I18n.t("referral_form.personal_details"),
          referrals_edit_personal_details_name_path(referral),
          section_status(:personal_details_complete)
        ),
        ReferralSectionItem.new(
          I18n.t("referral_form.contact_details"),
          referrals_edit_contact_details_email_path(referral),
          section_status(:contact_details_complete)
        ),
        ReferralSectionItem.new(
          I18n.t("referral_form.about_their_role"),
          referrals_edit_teacher_role_start_date_path(referral),
          section_status(:teacher_role_complete)
        )
      ]
    )
  end

  def the_allegation_section
    ReferralSection.new(
      3,
      I18n.t("referral_form.the_allegation"),
      [
        ReferralSectionItem.new(
          I18n.t("referral_form.details_of_the_allegation"),
          referrals_edit_allegation_details_path(referral),
          section_status(:allegation_details_complete)
        ),
        ReferralSectionItem.new(
          I18n.t("referral_form.previous_allegations"),
          edit_referral_previous_misconduct_reported_path(referral),
          referral.previous_misconduct_status
        ),
        ReferralSectionItem.new(
          I18n.t("referral_form.evidence_and_supporting_information"),
          section_path(
            section_status(:evidence_details_complete),
            referrals_edit_evidence_start_path(referral),
            referrals_edit_evidence_check_answers_path(referral)
          ),
          section_status(:evidence_details_complete)
        )
      ]
    )
  end

  def section_status(section_complete_method)
    status = referral.send(section_complete_method)
    return :not_started_yet if status.nil?

    status ? :completed : :incomplete
  end

  def section_path(status, start_path, check_answers_path)
    return start_path if status == :not_started_yet

    check_answers_path
  end
end
