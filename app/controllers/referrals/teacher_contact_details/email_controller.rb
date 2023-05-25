module Referrals
  module TeacherContactDetails
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
          EmailForm.new(contact_details_email_form_params.merge(referral: current_referral))
        if @contact_details_email_form.save
          redirect_to @contact_details_email_form.next_path
        else
          render :edit
        end
      end

      private

      def contact_details_email_form_params
        params.require(:referrals_teacher_contact_details_email_form).permit(
          :email_known,
          :email_address
        )
      end
    end
  end
end
