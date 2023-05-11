module EligibilityScreener
  class UnsupervisedTeachingForm < EligibilityScreenerForm
    attr_eligibility_check :unsupervised_teaching

    validates :unsupervised_teaching, inclusion: { in: %w[yes no not_sure] }

    def save
      return false unless valid?

      eligibility_check.unsupervised_teaching = unsupervised_teaching
      eligibility_check.save
    end
  end
end
