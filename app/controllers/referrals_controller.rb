class ReferralsController < Referrals::BaseController
  before_action :check_employer_form_feature_flag_enabled

  def new
  end

  def create
    referral = current_user.referrals.create
    redirect_to referral_path(referral)
  end

  def show
    @referral_form = ReferralForm.new(referral:)
  end

  def edit
    @referral_form = ReferralForm.new(referral:)
  end

  def update
    @referral_form = ReferralForm.new(referral:)

    if @referral_form.save
      # TODO: TBC
    else
      render :edit
    end
  end

  def destroy
    referral.destroy!
    redirect_to deleted_referrals_path
  end

  def delete
    referral if params[:id]

    render :delete
  end

  private

  def referral
    @referral ||= current_user.referrals.find(params[:id])
  end

  def check_employer_form_feature_flag_enabled
    unless FeatureFlags::FeatureFlag.active?(:employer_form)
      redirect_to start_path
    end
  end
end
