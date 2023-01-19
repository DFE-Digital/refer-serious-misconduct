class Referrer < ApplicationRecord
  belongs_to :referral

  def first_name
    name.split(" ").first
  end

  def last_name
    name.split(" ")[1]
  end

  def completed?
    completed_at.present?
  end

  def status
    return :completed if completed?

    :incomplete
  end
end
