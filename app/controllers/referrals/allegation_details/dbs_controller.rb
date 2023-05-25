module Referrals
  module AllegationDetails
    class DbsController < Referrals::BaseController
      def edit
        @allegation_dbs_form = DbsForm.new(dbs_notified: current_referral.dbs_notified)
      end

      def update
        @allegation_dbs_form = DbsForm.new(allegation_dbs_params.merge(referral: current_referral))

        if @allegation_dbs_form.save
          redirect_to @allegation_dbs_form.next_path
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
