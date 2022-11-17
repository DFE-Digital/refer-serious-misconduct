class PreviousMisconductReportedForm
  include ActiveModel::Model

  attr_accessor :referral
  attr_writer :previous_misconduct_reported

  validates :referral, presence: true
  validates :previous_misconduct_reported,
            inclusion: {
              in: %w[true false i_dont_know]
            }

  def previous_misconduct_reported
    @previous_misconduct_reported || referral&.previous_misconduct_reported
  end

  def save
    return false unless valid?

    referral.previous_misconduct_reported = previous_misconduct_reported
    referral.save
  end
end
