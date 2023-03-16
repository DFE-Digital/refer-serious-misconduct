module Referrals
  module PersonalDetails
    class NiNumberController < Referrals::BaseController
      def edit
        @ni_number_form =
          NiNumberForm.new(ni_number: current_referral.ni_number, ni_number_known: current_referral.ni_number_known)
      end

      def update
        @ni_number_form = NiNumberForm.new(ni_number_form_params.merge(referral: current_referral))
        if @ni_number_form.save
          redirect_to next_page
        else
          render :edit
        end
      end

      private

      def ni_number_form_params
        params.require(:referrals_personal_details_ni_number_form).permit(:ni_number, :ni_number_known)
      end

      def next_path
        [:edit, current_referral.routing_scope, current_referral, :personal_details, :trn]
      end
    end
  end
end
