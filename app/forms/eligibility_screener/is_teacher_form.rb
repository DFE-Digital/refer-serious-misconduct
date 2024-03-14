module EligibilityScreener
  class IsTeacherForm < EligibilityScreenerForm
    attr_eligibility_check :is_teacher

    validates :is_teacher, inclusion: { in: %w[yes no] }

    def save
      return false unless valid?

      eligibility_check.is_teacher = @is_teacher
      eligibility_check.save
    end

    def teacher?
      is_teacher == "yes"
    end
  end
end
