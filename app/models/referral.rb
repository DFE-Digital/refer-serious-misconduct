class Referral < ApplicationRecord
  has_one :organisation, dependent: :destroy
  has_one :referrer, dependent: :destroy
  has_one_attached :allegation_upload, dependent: :destroy
  has_one_attached :previous_misconduct_upload, dependent: :destroy
  has_one_attached :duties_upload, dependent: :destroy
  has_many :evidences,
           -> { order(:filename) },
           class_name: "ReferralEvidence",
           dependent: :destroy

  belongs_to :user

  def organisation_status
    return :not_started_yet if organisation.blank?

    organisation.status
  end

  def previous_misconduct_reported?
    return true if previous_misconduct_reported == "true"

    false
  end

  def previous_misconduct_status
    return :complete if previous_misconduct_completed_at.present?
    return :incomplete if previous_misconduct_deferred_at.present?

    :not_started_yet
  end

  def referrer_status
    return :not_started_yet if referrer.blank?

    referrer.status
  end
end
