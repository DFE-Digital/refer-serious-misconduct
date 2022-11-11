module Referrals
  module ContactDetails
    class EmailController < Referrals::BaseController
      def edit
        @contact_details_email_form =
          EmailForm.new(
            email_known: current_referral.email_known,
            email_address: current_referral.email_address
          )
      end

      def update
        @contact_details_email_form =
          EmailForm.new(
            contact_details_email_form_params.merge(referral: current_referral)
          )
        if @contact_details_email_form.save
          redirect_to save_redirect_path
        else
          render :edit
        end
      end

      private

      def contact_details_email_form_params
        params.require(:referrals_contact_details_email_form).permit(
          :email_known,
          :email_address
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

        referrals_update_contact_details_telephone_path(current_referral)
      end
    end
  end
end
