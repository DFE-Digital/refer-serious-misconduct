module Referrals
  class SummaryComponent < ReferralFormBaseComponent
    def call
      render(SummaryCardComponent.new(rows:, section:, editable:, error:))
    end
  end
end
