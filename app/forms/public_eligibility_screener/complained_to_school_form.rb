module PublicEligibilityScreener
  class ComplainedToSchoolForm < PublicEligibilityScreenerForm
    attr_eligibility_check :complaint_status

    validates :complaint_status, inclusion: { in: %w[received awaiting no] }

    def save
      return false unless valid?
      eligibility_check.complained = complained?
      eligibility_check.complaint_status = complaint_status
      eligibility_check.save
    end

    def complained?
      complaint_status != "no"
    end
  end
end