module PublicEligibilityScreener
  class ReportingAsForm < PublicEligibilityScreenerForm
    attr_eligibility_check :reporting_as

    validates :reporting_as, presence: true

    def save
      return false unless valid?

      eligibility_check.reporting_as = @reporting_as
      eligibility_check.save
    end
  end
end
