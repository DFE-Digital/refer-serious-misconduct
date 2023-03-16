module Users
  class ReferralsController < Referrals::BaseController
    def index
      @referrals_submitted = current_user.referrals.submitted.order(submitted_at: :desc)
      @referral_in_progress = current_user.referral_in_progress
    end

    def show
      @referral = current_user.referrals.find(params[:id])
    end
  end
end
