module ManageInterface
  class ReferralSummaryComponent < ViewComponent::Base
    include ActiveModel::Model
    include ReferralHelper

    attr_accessor :referral

    def rows
      summary_rows [referral_id_row, referral_date_row]
    end

    def title
      "Summary"
    end

    private

    def referral_id_row
      { label: "Referral ID", value: referral.id }
    end

    def referral_date_row
      { label: "Referral date", value: referral.created_at.to_fs(:day_month_year_time) }
    end
  end
end
