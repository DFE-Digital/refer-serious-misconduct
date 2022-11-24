class PreviousMisconductDetailedAccountForm
  include ActiveModel::Model

  attr_accessor :referral
  attr_writer :details, :format, :upload

  validates :details, presence: true, if: -> { format == "details" }
  validates :format, inclusion: { in: %w[details incomplete upload] }
  validates :referral, presence: true
  validates :upload, presence: true, if: -> { format == "upload" }

  def details
    @details || referral&.previous_misconduct_details
  end

  def upload
    @upload || referral&.previous_misconduct_upload
  end

  def format
    return @format if @format
    if referral&.previous_misconduct_details_incomplete_at.present?
      return "incomplete"
    end
    return "details" if referral&.previous_misconduct_details.present?
    return "upload" if referral&.previous_misconduct_upload&.attached?

    nil
  end

  def save
    return false unless valid?

    referral.previous_misconduct_details = details if format == "details"
    referral.previous_misconduct_upload.attach(upload) if format == "upload"
    referral.previous_misconduct_details_incomplete_at =
      format == "incomplete" ? Time.current : nil
    referral.save
  end
end
