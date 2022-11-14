class PreviousMisconductForm
  include ActiveModel::Model

  attr_accessor :referral
  attr_writer :complete

  validates :complete, inclusion: { in: %w[true false] }
  validates :referral, presence: true

  def complete
    @complete || previous_misconduct_completed_at? || nil
  end

  def save
    return false unless valid?

    referral.previous_misconduct_completed_at = Time.current if complete ==
      "true"
    referral.previous_misconduct_deferred_at = Time.current if complete ==
      "false"
    referral.save
  end

  delegate :previous_misconduct_completed_at?, to: :referral, allow_nil: true
end
