class ReferralsController < Referrals::BaseController
  before_action :check_employer_form_feature_flag_enabled
  before_action :redirect_to_referral_if_exists, only: %i[new create]

  def new
  end

  def create
    referral = current_user.referrals.create
    redirect_to edit_referral_path(referral)
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
      redirect_to referral_confirmation_path(referral)
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

  def redirect_to_referral_if_exists
    latest_referral = current_user.latest_referral

    redirect_to edit_referral_path(latest_referral) if latest_referral
  end

  def referral
    @referral ||= current_user.referrals.find(params[:id])
  end
  helper_method :referral

  def check_employer_form_feature_flag_enabled
    unless FeatureFlags::FeatureFlag.active?(:employer_form)
      redirect_to start_path
    end
  end
end
