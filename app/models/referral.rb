class Referral < ApplicationRecord
  include Zippable

  belongs_to :eligibility_check, dependent: :destroy
  belongs_to :user

  has_one :organisation, dependent: :destroy
  has_one :referrer, dependent: :destroy
  has_one_attached :allegation_upload, dependent: :destroy
  has_one_attached :previous_misconduct_upload, dependent: :destroy
  has_one_attached :duties_upload, dependent: :destroy
  has_many :evidences,
           -> { order(:created_at) },
           class_name: "ReferralEvidence",
           dependent: :destroy

  scope :employer,
        -> {
          joins(:eligibility_check).where(
            eligibility_check: {
              reporting_as: :employer
            }
          )
        }

  scope :member_of_public,
        -> {
          joins(:eligibility_check).where(
            eligibility_check: {
              reporting_as: :public
            }
          )
        }

  scope :submitted, -> { where.not(submitted_at: nil) }

  delegate :name, to: :referrer, prefix: true, allow_nil: true

  def routing_scope
    return :public if from_member_of_public?

    nil
  end

  def from_employer?
    eligibility_check.reporting_as_employer?
  end

  def from_member_of_public?
    eligibility_check.reporting_as_public?
  end

  def organisation_status
    return :not_started_yet if organisation.blank?

    organisation.status
  end

  def previous_misconduct_reported?
    return true if previous_misconduct_reported == "true"

    false
  end

  def previous_misconduct_status
    return :completed if previous_misconduct_completed_at.present?
    return :incomplete if previous_misconduct_deferred_at.present?

    :not_started_yet
  end

  def referrer_status
    return :not_started_yet if referrer.blank?

    referrer.status
  end

  def working_somewhere_else?
    working_somewhere_else == "yes"
  end

  def left_role?
    employment_status == "left_role"
  end

  def name
    [first_name, last_name].join(" ")
  end
end
