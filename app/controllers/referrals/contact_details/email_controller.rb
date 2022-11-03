module Referrals
  module ContactDetails
    class EmailController < ReferralsController
      def edit
        @contact_details_email_form =
          EmailForm.new(
            email_known: referral.email_known,
            email_address: referral.email_address
          )
      end

      def update
        @contact_details_email_form =
          EmailForm.new(contact_details_email_form_params.merge(referral:))
        if @contact_details_email_form.save
          # TODO: Redirect to personal details telephone
          redirect_to referrals_update_contact_details_address_path(referral)
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
    end
  end
end
