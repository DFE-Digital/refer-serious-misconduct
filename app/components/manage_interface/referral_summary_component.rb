module ManageInterface
  class ReferralSummaryComponent < ViewComponent::Base
    include ActiveModel::Model

    attr_accessor :referral

    def rows
      [
        { key: { text: "Referral ID" }, value: { text: referral.id } },
        {
          key: {
            text: "Referral date"
          },
          value: {
            text: referral.created_at.to_fs(:day_month_year_time)
          }
        }
      ]
    end

    def title
      "Summary"
    end
  end
end
