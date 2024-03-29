module Referrals
  module AllegationPreviousMisconduct
    class ReportedController < Referrals::BaseController
      def edit
        @form = ReportedForm.new(
          referral: current_referral,
          changing:,
        )
      end

      def update
        @form = ReportedForm.new(
          reported_form_params.merge(
            referral: current_referral,
            changing:,
          )
        )
        if @form.save
          redirect_to @form.next_path
        else
          render :edit
        end
      end

      private

      def reported_form_params
        params.require(:referrals_allegation_previous_misconduct_reported_form).permit(
          :previous_misconduct_reported
        )
      end
    end
  end
end
