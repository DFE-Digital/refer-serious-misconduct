module Referrals
  class BaseController < ApplicationController
    include AuthenticateUser
    include StoreUserLocation
    include RedirectIfFeatureFlagInactive
    include RedirectIfReferralSubmitted

    before_action { redirect_if_feature_flag_inactive(:referral_form) }

    def edit
    end

    private

    def current_referral
      id = params[:id] || params[:referral_id] || params[:public_referral_id]

      return nil if id.blank?

      @current_referral ||= current_user.referrals.find(id)
    end
    helper_method :current_referral

    def back_link_url
      polymorphic_path(form.previous_path)
    end
    helper_method :back_link_url

    delegate :page_title, :section_label, :form_path, to: :form
    helper_method :page_title, :section_label, :form_path

    delegate :label, to: :form, prefix: true
    helper_method :form_label

    attr_reader :form
    helper_method :form

    def changing
      params[:return_to].present?
    end
  end
end
