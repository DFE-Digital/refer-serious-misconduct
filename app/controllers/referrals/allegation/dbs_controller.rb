module Referrals
  module Allegation
    class DbsController < Referrals::BaseController
      def edit
        @allegation_dbs_form =
          DbsForm.new(dbs_notified: current_referral.dbs_notified)
      end

      def update
        @allegation_dbs_form =
          DbsForm.new(allegation_dbs_params.merge(referral: current_referral))

        if @allegation_dbs_form.save
          redirect_to next_page
        else
          render :edit
        end
      end

      private

      def allegation_dbs_params
        params.fetch(:referrals_allegation_dbs_form, {}).permit(:dbs_notified)
      end

      def next_path
        [
          :edit,
          current_referral.routing_scope,
          current_referral,
          :allegation,
          :check_answers
        ]
      end
    end
  end
end
