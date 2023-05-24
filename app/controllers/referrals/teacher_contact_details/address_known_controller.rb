module Referrals
  module ContactDetails
    class AddressKnownController < Referrals::BaseController
      def edit
        @contact_details_address_known_form =
          AddressKnownForm.new(address_known: current_referral.address_known)
      end

      def update
        @contact_details_address_known_form =
          AddressKnownForm.new(
            contact_details_address_known_form_params.merge(referral: current_referral)
          )
        if @contact_details_address_known_form.save
          redirect_to @contact_details_address_known_form.next_path
        else
          render :edit
        end
      end

      private

      def contact_details_address_known_form_params
        params.require(:referrals_contact_details_address_known_form).permit(:address_known)
      end
    end
  end
end
