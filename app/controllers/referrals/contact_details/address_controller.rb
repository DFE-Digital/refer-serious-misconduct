module Referrals
  module ContactDetails
    class AddressController < ReferralsController
      def edit
        @contact_details_address_form =
          AddressForm.new(
            address_known: referral.address_known,
            address_line_1: referral.address_line_1,
            address_line_2: referral.address_line_2,
            town_or_city: referral.town_or_city,
            postcode: referral.postcode,
            country: referral.country
          )
      end

      def update
        @contact_details_address_form =
          AddressForm.new(contact_details_address_form_params.merge(referral:))
        if @contact_details_address_form.save
          # TODO: Redirect to check answers page
          redirect_to edit_referral_path(referral)
        else
          render :edit
        end
      end

      private

      def contact_details_address_form_params
        params.require(:referrals_contact_details_address_form).permit(
          :address_known,
          :address_line_1,
          :address_line_2,
          :town_or_city,
          :postcode,
          :country
        )
      end
    end
  end
end
