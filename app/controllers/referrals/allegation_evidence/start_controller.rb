module Referrals
  module AllegationEvidence
    class StartController < Referrals::BaseController
      include ReferralHelper

      def edit
        @form =
          StartForm.new(
            referral: current_referral,
            changing:,
            has_evidence: current_referral.has_evidence
          )
      end

      def update
        @form = StartForm.new(
          start_params.merge(
            referral: current_referral,
            changing:,
          )
        )

        if @form.save
          redirect_path = [
            :edit,
            current_referral.routing_scope,
            current_referral,
            :allegation_evidence
          ]
          @form.has_evidence ? redirect_path.push(:upload) : redirect_path.push(:check_answers)
          redirect_to redirect_path
        else
          render :edit
        end
      end

      private

      def start_params
        params.fetch(:referrals_allegation_evidence_start_form, {}).permit(:has_evidence)
      end
    end
  end
end
