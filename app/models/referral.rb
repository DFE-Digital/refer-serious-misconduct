class Referral < ApplicationRecord
  include Uploadable

  belongs_to :eligibility_check, dependent: :destroy
  belongs_to :user

  has_one :organisation, dependent: :destroy
  has_one :referrer, dependent: :destroy
  # has_one_attached :allegation_upload
  has_one_attached :previous_misconduct_upload
  has_one_attached :duties_upload
  has_one_attached :pdf

  # has_one :allegation_upload, -> { where(section: :allegation) }, class_name: "Upload", dependent: :destroy, foreign_key: :uploadable_id
  # has_one :previous_misconduct_upload, -> { where(section: :previous_misconduct) }, class_name: "Upload", dependent: :destroy, foreign_key: :uploadable_id
  # has_one :duties_upload, -> { where(section: :duties) }, class_name: "Upload", dependent: :destroy, foreign_key: :uploadable_id
  # has_one :pdf, -> { where(section: :pdf) }, class_name: "Upload", dependent: :destroy, foreign_key: :uploadable_id

  # def allegation_attachment
  #   allegation_upload&.attachment
  # end

  has_one_uploaded :allegation

  has_many :evidences,
           -> { order(:created_at) },
           class_name: "ReferralEvidence",
           dependent: :destroy
  has_many :reminder_emails, dependent: :destroy

  scope :employer,
        -> { joins(:eligibility_check).where(eligibility_check: { reporting_as: :employer }) }
  scope :member_of_public,
        -> { joins(:eligibility_check).where(eligibility_check: { reporting_as: :public }) }
  scope :submitted, -> { where.not(submitted_at: nil) }
  scope :stale_drafts, -> { where(submitted_at: nil).where("updated_at < ?", 90.days.ago) }
  scope :stale_drafts_reminder,
        -> { where(submitted_at: nil).where("updated_at <= ?", 83.days.ago) }

  delegate :name, to: :referrer, prefix: true, allow_nil: true

  def submit
    self.declaration = DeclarationRenderer.new.render

    update(submitted_at: Time.current) && RenderPdfJob.perform_later(referral: self)
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

  def submitted?
    submitted_at.present?
  end
end
