class Referral < ApplicationRecord
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

  def submit
    update(submitted_at: Time.current)
  end

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

  def name_has_changed?
    name_has_changed == "yes"
  end

  def previous_misconduct_reported?
    return true if previous_misconduct_reported == "true"

    false
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
