class Referrer < ApplicationRecord
  belongs_to :referral

  def completed?
    completed_at.present?
  end

  def status
    return :complete if completed?

    :incomplete
  end
end
