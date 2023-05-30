module Referrals
  module AllegationDetails
    class DbsController < Referrals::BaseController
      def edit
        @form = DbsForm.new(referral: current_referral, dbs_notified: current_referral.dbs_notified)
      end

      def update
        @form = DbsForm.new(allegation_dbs_params.merge(referral: current_referral))

        if @form.save
          redirect_to @form.next_path
        else
          render :edit
        end
      end

      private

      def allegation_dbs_params
        params.fetch(:referrals_allegation_details_dbs_form, {}).permit(:dbs_notified)
      end
    end
  end
end
