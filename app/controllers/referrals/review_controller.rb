module Referrals
  class ReviewController < BaseController
    def show
      @referral_form = ReferralForm.new(referral:)
    end

    def update
      @referral_form = ReferralForm.new(referral:)

      if @referral_form.submit
        CaseworkerMailer.referral_submitted(current_referral).deliver_later
        UserMailer.referral_submitted(current_referral).deliver_later
        redirect_to [current_referral.routing_scope, current_referral, :confirmation]
      else
        render :show
      end
    end

    private

    def referral
      @referral ||= current_user.referrals.employer.find(params[:referral_id])
    end
    helper_method :referral

    def back_linked_error_presenter
      BackLinkedErrorSummaryPresenter.new(
        @referral_form.errors.messages,
        polymorphic_path([:edit, current_referral.routing_scope, current_referral])
      )
    end
    helper_method :back_linked_error_presenter
  end
end
