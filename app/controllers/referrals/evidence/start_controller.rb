module Referrals
  module Evidence
    class StartController < Referrals::BaseController
      include ReferralHelper

      def edit
        @evidence_start_form = StartForm.new(has_evidence: current_referral.has_evidence)
      end

      def update
        @evidence_start_form = StartForm.new(start_params.merge(referral: current_referral))

        if @evidence_start_form.save
          redirect_path = [:edit, current_referral.routing_scope, current_referral]
          if @evidence_start_form.has_evidence
            redirect_path.push(:evidence_upload)
          else
            redirect_path.push(:evidence_check_answers)
          end
          redirect_to redirect_path
        else
          render :edit
        end
      end

      private

      def start_params
        params.fetch(:referrals_evidence_start_form, {}).permit(:has_evidence)
      end
    end
  end
end
