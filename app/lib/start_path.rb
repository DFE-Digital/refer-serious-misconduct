class StartPath
  include Rails.application.routes.url_helpers

  class << self
    def for(user:)
      new(user:).start_path
    end
  end

  def initialize(user:)
    @user = user
  end

  private_class_method :new

  def start_path
    if FeatureFlags::FeatureFlag.active?(:referral_form)
      return path_when_user_present if user.present?

      users_registrations_exists_path
    else
      referral_type_path
    end
  end

  private

  attr_reader :user

  def path_when_user_present
    return users_referrals_path if referrals_submitted?
    return edit_path_for_referral(user.referral_in_progress) if user.referral_in_progress.present?

    referral_type_path
  end

  def referrals_submitted?
    user.referrals.submitted.any?
  end

  def edit_path_for_referral(referral)
    polymorphic_path([:edit, referral.routing_scope, referral])
  end
end
