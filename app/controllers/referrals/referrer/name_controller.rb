module Referrals
  module Referrer
    class NameController < Referrals::BaseController
      def edit
        @referrer_name_form = Referrals::Referrer::NameForm.new(referral: current_referral)
      end

      def update
        @referrer_name_form =
          Referrals::Referrer::NameForm.new(name_params.merge(referral: current_referral))
        if @referrer_name_form.save
          redirect_to @referrer_name_form.next_path
        else
          render :edit
        end
      end

      private

      def name_params
        params.require(:referrals_referrer_name_form).permit(:first_name, :last_name)
      end

      def previous_path
        polymorphic_path([:edit, current_referral.routing_scope, current_referral])
      end
      helper_method :previous_path
    end
  end
end
