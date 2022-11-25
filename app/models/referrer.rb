class Referrer < ApplicationRecord
  belongs_to :referral

  def completed?
    completed_at.present?
  end

  def status
    return :completed if completed?

    :incomplete
  end
end
