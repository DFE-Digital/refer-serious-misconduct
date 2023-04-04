module Referrals
  module PreviousMisconduct
    class ReportedController < Referrals::BaseController
      def edit
        @reported_form = ReportedForm.new(referral: current_referral)
      end

      def update
        @reported_form = ReportedForm.new(reported_form_params.merge(referral: current_referral))
        if @reported_form.save
          if current_referral.previous_misconduct_reported?
            redirect_to next_page
          else
            redirect_to edit_referral_previous_misconduct_check_answers_path(current_referral)
          end
        else
          render :edit
        end
      end

      private

      def reported_form_params
        params.require(:referrals_previous_misconduct_reported_form).permit(
          :previous_misconduct_reported
        )
      end

      def next_path
        [
          :edit,
          current_referral.routing_scope,
          current_referral,
          :previous_misconduct,
          :detailed_account
        ]
      end

      def next_page
        return next_path if @reported_form.referral.saved_changes?

        super
      end
    end
  end
end
