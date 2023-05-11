module EligibilityScreener
  class HaveComplainedForm < EligibilityScreenerForm
    attr_eligibility_check :complained

    validates :complained, inclusion: { in: [true, false] }

    def save
      return false unless valid?

      eligibility_check.complained = complained
      eligibility_check.save
    end
  end
end
