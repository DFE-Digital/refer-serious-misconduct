module EligibilityScreener
  class RecentlyComplainedForm
    include ActiveModel::Model

    attr_accessor :eligibility_check
    attr_reader :recently_complained

    validates :eligibility_check, presence: true
    validates :recently_complained, inclusion: { in: [true, false] }

    def recently_complained=(value)
      @recently_complained = ActiveModel::Type::Boolean.new.cast(value)
    end

    def save
      return false unless valid?

      eligibility_check.recently_complained = recently_complained
      eligibility_check.save
    end
  end
end
