class Upload < ApplicationRecord
  after_create_commit :save_filename
  after_create_commit :malware_scan

  belongs_to :uploadable, polymorphic: true
  has_one_attached :file, dependent: :purge_later
  validates :file, presence: true

  enum section: {
         allegation: "allegation",
         duties: "duties",
         previous_misconduct: "previous_misconduct",
         evidence: "evidence"
       }

  enum malware_scan_result: {
         clean: "clean",
         error: "error",
         pending: "pending",
         suspect: "suspect"
       },
       _prefix: :scan_result

  def save_filename
    update(filename: file.filename.to_s)
  end

  def malware_scan
    return unless file.attached? && FeatureFlags::FeatureFlag.active?(:malware_scan)

    FetchMalwareScanResultJob.set(wait: 30.seconds).perform_later(upload: self)
  end
end
