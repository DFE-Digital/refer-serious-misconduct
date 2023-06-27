module EligibilityScreener
  class SeriousMisconductForm < EligibilityScreenerForm
    attr_eligibility_check :continue_with

    validates :continue_with, inclusion: { in: %w[referral complaint] }

    def save
      return false unless valid?

      eligibility_check.continue_with = continue_with
      eligibility_check.save
    end
  end
end
