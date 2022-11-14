class PreviousMisconductSummaryForm
  include ActiveModel::Model

  attr_accessor :referral
  attr_writer :summary

  validates :summary, presence: true
  validates :referral, presence: true

  def summary
    @summary ||= referral&.previous_misconduct_summary
  end

  def save
    return false unless valid?

    referral.update(previous_misconduct_summary: summary)
  end
end
