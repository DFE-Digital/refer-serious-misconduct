class ReferralsController < Referrals::BaseController
  before_action :check_referral_form_feature_flag_enabled
  before_action :redirect_to_referral_if_exists, only: %i[new create]
  before_action :redirect_to_screener_if_no_id_in_session, only: %i[new create]

  def new
    new_referral =
      current_user.find_or_create_referral!(
        eligibility_check_id: session.delete(:eligibility_check_id)
      )
    redirect_to [:edit, new_referral.routing_scope, new_referral]
  end

  def create
    new_referral =
      current_user.create_referral!(
        eligibility_check_id: session.delete(:eligibility_check_id)
      )
    redirect_to [:edit, new_referral.routing_scope, new_referral]
  end

  def edit
    @referral_form = ReferralForm.new(referral:)
  end

  def update
    @referral_form = ReferralForm.new(referral:)

    if @referral_form.save
      redirect_to review_path
    else
      render :edit
    end
  end

  private

  def referral
    @referral ||= current_user.referrals.employer.find(params[:id])
  end
  helper_method :referral

  def check_referral_form_feature_flag_enabled
    unless FeatureFlags::FeatureFlag.active?(:referral_form)
      redirect_to start_path
    end
  end

  def redirect_to_screener_if_no_id_in_session
    redirect_to referral_type_path if session[:eligibility_check_id].blank?
  end

  def review_path
    [referral.routing_scope, referral, :review]
  end
end
