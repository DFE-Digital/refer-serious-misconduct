module Referrals
  module AllegationPrevious
    class ReportedController < Referrals::BaseController
      def edit
        @reported_form = ReportedForm.new(referral: current_referral)
      end

      def update
        @reported_form = ReportedForm.new(reported_form_params.merge(referral: current_referral))
        if @reported_form.save
          redirect_to @reported_form.next_path
        else
          render :edit
        end
      end

      private

      def reported_form_params
        params.require(:referrals_allegation_previous_reported_form).permit(
          :previous_misconduct_reported
        )
      end
    end
  end
end
