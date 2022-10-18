module SupportInterface
  class EligibilityChecksController < ApplicationController
    def index
      @eligibility_checks = EligibilityCheck.order(updated_at: :desc).limit(100)
    end
  end
end
