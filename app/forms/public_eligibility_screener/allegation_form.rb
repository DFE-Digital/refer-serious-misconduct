module PublicEligibilityScreener
  class AllegationForm < PublicEligibilityScreenerForm
    attr_eligibility_check :serious_misconduct

    validate :serious_misconduct_checked

    def save
      return false unless valid?
      eligibility_check.serious_misconduct = @serious_misconduct
      eligibility_check.save
    end

    def serious_misconduct_checked
      @serious_misconduct = @serious_misconduct.reject(&:empty?)
      if @serious_misconduct == []
        errors.add(:serious_misconduct, "Select whether your allegation involves any of the following")
      end
    end
  end
end