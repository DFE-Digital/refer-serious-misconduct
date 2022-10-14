class ReportingAsForm
  include ActiveModel::Model

  attr_accessor :eligibility_check, :reporting_as

  validates :eligibility_check, presence: true
  validates :reporting_as, presence: true

  def save
    return false unless valid?

    eligibility_check.reporting_as = reporting_as
    eligibility_check.save
  end
end
