class ReferralForm
  include Rails.application.routes.url_helpers
  include ActiveModel::Model
  include ReferralHelper
  include ValidationTracking

  attr_accessor :referral

  validate :sections_valid

  def save
    valid?
  end

  def submit
    return false if !valid? || referral.submitted?

    referral.submit
  end

  def items
    [about_you_section, about_the_person_you_are_referring_section, the_allegation_section]
  end
  alias_method :sections, :items

  private

  def sections_valid
    invalid_sections.each do |section|
      errors.add(
        "section.#{section.slug}",
        I18n.t("validation_errors.incomplete_section.#{section.slug}")
      )
    end
  end

  def invalid_sections
    items.flat_map { |item| item.sections.select(&:incomplete?) }
  end

  def about_you_section
    items = [
      Referrals::Sections::ReferrerSection.new(referral:),
      referral.from_employer? && Referrals::Sections::OrganisationSection.new(referral:)
    ].compact_blank

    Referrals::SectionGroup.new(slug: "about_you", items:)
  end

  def about_the_person_you_are_referring_section
    items = [
      Referrals::Sections::PersonalDetailsSection.new(referral:),
      referral.from_employer? && Referrals::Sections::ContactDetailsSection.new(referral:),
      Referrals::Sections::TeacherRoleSection.new(referral:)
    ].compact_blank

    Referrals::SectionGroup.new(slug: "about_the_person_you_are_referring", items:)
  end

  def the_allegation_section
    items = [
      Referrals::Sections::AllegationSection.new(referral:),
      referral.from_employer? && Referrals::Sections::PreviousMisconductSection.new(referral:),
      Referrals::Sections::EvidenceSection.new(referral:)
    ].compact_blank

    Referrals::SectionGroup.new(slug: "the_allegation", items:)
  end
end
