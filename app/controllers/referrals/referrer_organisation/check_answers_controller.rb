module Referrals
  module ReferrerOrganisation
    class CheckAnswersController < BaseController
      def edit
        @organisation = current_referral.organisation || current_referral.build_organisation
        @form = CheckAnswersForm.new(referral: current_referral, complete: @organisation.complete)
      end

      def update
        @form =
          CheckAnswersForm.new(complete: organisation_params[:complete], referral: current_referral)

        if @form.save
          redirect_to [:edit, current_referral.routing_scope, current_referral]
        else
          @organisation = current_referral.organisation
          render :edit
        end
      end

      private

      def organisation_params
        params.require(:referrals_referrer_organisation_check_answers_form).permit(:complete)
      end
    end
  end
end
