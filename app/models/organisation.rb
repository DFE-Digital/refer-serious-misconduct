class Organisation < ApplicationRecord
  belongs_to :referral

  def address?
    street_1.present? && city.present? && postcode.present?
  end

  def completed?
    completed_at.present?
  end

  def status
    return :completed if completed?

    :incomplete
  end
end
