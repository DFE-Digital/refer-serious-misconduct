module Referrals
  module ContactDetails
    class AddressController < Referrals::BaseController
      def edit
        @contact_details_address_form =
          AddressForm.new(
            address_known: current_referral.address_known,
            address_line_1: current_referral.address_line_1,
            address_line_2: current_referral.address_line_2,
            town_or_city: current_referral.town_or_city,
            postcode: current_referral.postcode,
            country: current_referral.country
          )
      end

      def update
        @contact_details_address_form =
          AddressForm.new(
            contact_details_address_form_params.merge(
              referral: current_referral
            )
          )
        if @contact_details_address_form.save
          redirect_to next_page
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

      def next_path
        edit_referral_contact_details_check_answers_path(current_referral)
      end
    end
  end
end
