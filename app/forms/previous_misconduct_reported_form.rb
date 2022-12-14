class PreviousMisconductReportedForm
  include ActiveModel::Model

  attr_accessor :referral
  attr_writer :previous_misconduct_reported

  validates :referral, presence: true
  validates :previous_misconduct_reported,
            inclusion: {
              in: %w[true false not_sure]
            }

  def previous_misconduct_reported
    @previous_misconduct_reported || referral&.previous_misconduct_reported
  end

  def save
    return false unless valid?

    referral.update(previous_misconduct_reported:)
  end
end
