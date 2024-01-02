module Referrals
  module TeacherContactDetails
    class EmailController < Referrals::BaseController
      def edit
        @form =
          EmailForm.new(
            referral: current_referral,
            changing:,
            email_known: current_referral.email_known,
            email_address: current_referral.email_address
          )
      end

      def update
        @form = EmailForm.new(
          contact_details_email_form_params.merge(
            referral: current_referral,
            changing:,
          )
        )
        if @form.save
          redirect_to @form.next_path
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
