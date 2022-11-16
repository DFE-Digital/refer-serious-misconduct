class Referral < ApplicationRecord
  has_one :organisation, dependent: :destroy
  has_one :referrer, dependent: :destroy
  belongs_to :user

  def organisation_status
    return :not_started_yet if organisation.blank?

    organisation.status
  end

  def referrer_status
    return :not_started_yet if referrer.blank?

    referrer.status
  end
end
