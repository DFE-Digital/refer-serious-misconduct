class Referral < ApplicationRecord
  belongs_to :eligibility_check, dependent: :destroy
  belongs_to :user

  has_one :organisation, dependent: :destroy
  has_one :referrer, dependent: :destroy
  has_one_attached :pdf

  has_many :uploads, as: :uploadable

  has_one :allegation_upload,
          -> { where(section: "allegation").order(created_at: :desc) },
          class_name: "Upload",
          foreign_key: :uploadable_id,
          dependent: :destroy
  delegate :file, to: :allegation_upload, prefix: true, allow_nil: true

  has_one :duties_upload,
          -> { where(section: "duties").order(created_at: :desc) },
          class_name: "Upload",
          foreign_key: :uploadable_id,
          dependent: :destroy
  delegate :file, to: :duties_upload, prefix: true, allow_nil: true

  has_one :previous_misconduct_upload,
          -> { where(section: "previous_misconduct").order(created_at: :desc) },
          class_name: "Upload",
          foreign_key: :uploadable_id,
          dependent: :destroy
  delegate :file, to: :previous_misconduct_upload, prefix: true, allow_nil: true

  has_many :evidence_uploads,
           -> { where(section: "evidence").order(:created_at) },
           class_name: "Upload",
           foreign_key: :uploadable_id,
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

  def can_upload_more_evidence?
    evidence_uploads.count < FileUploadValidator::MAX_FILES
  end
end
