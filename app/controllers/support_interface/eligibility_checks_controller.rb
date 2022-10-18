module SupportInterface
  class EligibilityChecksController < SupportInterfaceController
    def index
      @eligibility_checks = EligibilityCheck.order(updated_at: :desc).limit(100)
    end
  end
end
