class ReferralsController < Referrals::BaseController
  before_action :check_referral_form_feature_flag_enabled
  before_action :redirect_to_referral_if_exists, only: %i[new create]
  before_action :redirect_to_screener_if_no_id_in_session, only: %i[new create]

  def new
  end

  def create
    eligibility_check =
      EligibilityCheck.find_by!(id: session.delete(:eligibility_check_id))
    referral =
      current_user.referrals.create!(eligibility_check_id: eligibility_check.id)

    redirect_to edit_referral_path(referral)
  end

  def edit
    @referral_form = ReferralForm.new(referral:)
  end

  def update
    @referral_form = ReferralForm.new(referral:)

    if @referral_form.save
      redirect_to referral_review_path(referral)
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

  def check_referral_form_feature_flag_enabled
    unless FeatureFlags::FeatureFlag.active?(:referral_form)
      redirect_to start_path
    end
  end

  def redirect_to_screener_if_no_id_in_session
    redirect_to who_path if session[:eligibility_check_id].blank?
  end
end
