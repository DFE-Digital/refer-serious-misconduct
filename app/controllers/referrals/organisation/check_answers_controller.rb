module Referrals
  module Organisation
    class CheckAnswersController < BaseController
      def edit
        @organisation = current_referral.organisation || current_referral.build_organisation
        @organisation_form = CheckAnswersForm.new(referral: current_referral, complete: @organisation.complete)
      end

      def update
        @organisation_form = CheckAnswersForm.new(complete: organisation_params[:complete], referral: current_referral)

        if @organisation_form.save
          redirect_to [:edit, current_referral.routing_scope, current_referral]
        else
          @organisation = current_referral.organisation
          render :edit
        end
      end

      private

      def organisation_params
        params.require(:referrals_organisation_check_answers_form).permit(:complete)
      end
    end
  end
end
