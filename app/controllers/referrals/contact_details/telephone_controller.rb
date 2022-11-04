module Referrals
  module ContactDetails
    class TelephoneController < ReferralsController
      def edit
        @contact_details_telephone_form =
          TelephoneForm.new(
            phone_known: referral.phone_known,
            phone_number: referral.phone_number
          )
      end

      def update
        @contact_details_telephone_form =
          TelephoneForm.new(
            contact_details_telephone_form_params.merge(referral:)
          )
        if @contact_details_telephone_form.save
          redirect_to referrals_update_contact_details_address_path(referral)
        else
          render :edit
        end
      end

      private

      def contact_details_telephone_form_params
        params.require(:referrals_contact_details_telephone_form).permit(
          :phone_known,
          :phone_number
        )
      end
    end
  end
end
