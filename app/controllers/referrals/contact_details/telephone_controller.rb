module Referrals
  module ContactDetails
    class TelephoneController < Referrals::BaseController
      def edit
        @contact_details_telephone_form =
          TelephoneForm.new(
            phone_known: current_referral.phone_known,
            phone_number: current_referral.phone_number
          )
      end

      def update
        @contact_details_telephone_form =
          TelephoneForm.new(
            contact_details_telephone_form_params.merge(
              referral: current_referral
            )
          )
        if @contact_details_telephone_form.save
          redirect_to save_redirect_path
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

      def save_redirect_path
        if go_to_check_answers?
          return(
            referrals_update_contact_details_check_answers_path(
              current_referral
            )
          )
        end

        referrals_update_contact_details_address_path(current_referral)
      end
    end
  end
end
