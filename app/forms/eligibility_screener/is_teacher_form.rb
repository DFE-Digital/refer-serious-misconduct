module EligibilityScreener
  class IsTeacherForm
    include ActiveModel::Model

    attr_accessor :eligibility_check, :is_teacher

    validates :eligibility_check, presence: true
    validates :is_teacher, inclusion: { in: %w[yes no not_sure] }

    def save
      return false unless valid?

      eligibility_check.is_teacher = is_teacher
      eligibility_check.save
    end
  end
end
