class AboutYouComponent < ViewComponent::Base
  include ActiveModel::Model
  include ReferralHelper
  include ComponentHelper

  delegate :referrer, to: :referral

  def rows
    summary_rows [name_row, email_row, job_title_row, phone_row].compact
  end

  private

  def name_row
    { label: "Your name", value: referrer&.name, path: :referrer_name }
  end

  def email_row
    { label: "Your email address", value: user.email }
  end

  def job_title_row
    return unless referral.from_employer?

    { label: "Your job title", value: referrer&.job_title, path: :referrer_job_title }
  end

  def phone_row
    { label: "Your phone number", value: referrer&.phone, path: :referrer_phone }
  end

  def section
    Referrals::Sections::ReferrerSection.new(referral:)
  end
end
