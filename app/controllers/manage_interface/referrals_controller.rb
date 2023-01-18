module ManageInterface
  class ReferralsController < ManageInterfaceController
    def index
      @referrals_count = Referral.count
      @pagy, @referrals = pagy(Referral.all)
    end

    def show
    end
  end
end
