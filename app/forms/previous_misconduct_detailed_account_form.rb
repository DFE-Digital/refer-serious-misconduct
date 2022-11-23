class PreviousMisconductDetailedAccountForm
  include ActiveModel::Model

  attr_accessor :referral
  attr_writer :details, :format

  validates :details, presence: true, if: -> { format == "details" }
  validates :format, inclusion: { in: %w[details incomplete] }
  validates :referral, presence: true

  def details
    @details || referral&.previous_misconduct_details
  end

  def format
    return @format if @format
    if referral&.previous_misconduct_details_incomplete_at.present?
      return "incomplete"
    end
    return "details" if referral&.previous_misconduct_details.present?

    nil
  end

  def save
    return false unless valid?

    referral.previous_misconduct_details = details if format == "details"
    referral.previous_misconduct_details_incomplete_at =
      format == "incomplete" ? Time.current : nil
    referral.save
  end
end
