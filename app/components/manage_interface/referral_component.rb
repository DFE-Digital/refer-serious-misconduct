module ManageInterface
  class ReferralComponent < ViewComponent::Base
    include ActiveModel::Model
    include ReferralHelper

    attr_accessor :referral

    def rows
      summary_rows [submitted_at, referrer_row].compact
    end

    def title
      "#{referral.first_name} #{referral.last_name}"
    end

    private

    def submitted_at
      { label: "Referral date", value: referral.submitted_at.to_fs(:day_month_year_time) }
    end

    def referrer_row
      { label: "Referrer", value: referral.referrer_name }
    end
  end
end
