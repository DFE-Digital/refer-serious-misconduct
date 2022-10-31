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
    unless sections.map(&:items).flatten.map(&:status).uniq == [:complete]
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
          "#",
          :not_started_yet
        ),
        ReferralSectionItem.new(
          I18n.t("referral_form.your_organisation"),
          "#",
          :not_started_yet
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
          :not_started_yet
        ),
        ReferralSectionItem.new(
          I18n.t("referral_form.contact_details"),
          "#",
          :not_started_yet
        ),
        ReferralSectionItem.new(
          I18n.t("referral_form.about_their_role"),
          "#",
          :not_started_yet
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
          "#",
          :not_started_yet
        ),
        ReferralSectionItem.new(
          I18n.t("referral_form.previous_allegations"),
          "#",
          :not_started_yet
        ),
        ReferralSectionItem.new(
          I18n.t("referral_form.evidence_and_supporting_information"),
          "#",
          :not_started_yet
        )
      ]
    )
  end
end
