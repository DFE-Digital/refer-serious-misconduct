module ManageInterface
  class ReferralsController < ManageInterfaceController
    def index
      @referrals_count = Referral.submitted.count
      @pagy, @referrals = pagy(Referral.submitted)
    end

    def show
      @referral = Referral.find(params[:id])
    end
  end
end
