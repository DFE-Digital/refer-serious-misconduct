module EligibilityScreener
  class SeriousMisconductForm
    include ActiveModel::Model

    attr_accessor :eligibility_check, :serious_misconduct

    validates :eligibility_check, presence: true
    validates :serious_misconduct, inclusion: { in: %w[yes no not_sure] }

    def save
      return false unless valid?

      eligibility_check.serious_misconduct = serious_misconduct
      eligibility_check.save
    end
  end
end
