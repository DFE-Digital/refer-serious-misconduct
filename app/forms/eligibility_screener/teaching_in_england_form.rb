module EligibilityScreener
  class TeachingInEnglandForm
    include ActiveModel::Model

    attr_accessor :eligibility_check, :teaching_in_england

    validates :eligibility_check, presence: true
    validates :teaching_in_england, inclusion: { in: %w[yes no not_sure] }

    def save
      return false unless valid?

      eligibility_check.teaching_in_england = teaching_in_england
      eligibility_check.save
    end
  end
end
