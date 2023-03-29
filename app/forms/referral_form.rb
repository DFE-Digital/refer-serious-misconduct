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
    [
      Referrals::SectionGroups::AboutYouSectionGroup.new(referral:)
      # Referrals::SectionGroups::AboutTheTeacherSectionGroup.new(referral:)
      # Referrals::SectionGroups::TheAllegationSection.new(referral:)
    ]
  end

  private

  def sections_valid
    errors.add(:base, :all_sections_complete) unless items.all?(&:complete?)
  end
end
