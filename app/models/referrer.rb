class Referrer < ApplicationRecord
  belongs_to :referral

  def completed?
    complete
  end

  def name
    [first_name, last_name].join(" ")
  end

  def status
    return :completed if completed?

    :incomplete
  end
end
