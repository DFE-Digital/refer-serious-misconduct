module ManageInterface
  class ReferralsController < ManageInterfaceController
    def index
      @referrals_count = Referral.count
      @pagy, @referrals = pagy(Referral.all)
    end

    def show
      @referral = Referral.find(params[:id])
    end
  end
end
