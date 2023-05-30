module Referrals
  module TeacherContactDetails
    class TelephoneController < Referrals::BaseController
      def edit
        @form =
          TelephoneForm.new(
            referral: current_referral,
            phone_known: current_referral.phone_known,
            phone_number: current_referral.phone_number
          )
      end

      def update
        @form =
          TelephoneForm.new(contact_details_telephone_form_params.merge(referral: current_referral))
        if @form.save
          redirect_to @form.next_path
        else
          render :edit
        end
      end

      private

      def contact_details_telephone_form_params
        params.require(:referrals_teacher_contact_details_telephone_form).permit(
          :phone_known,
          :phone_number
        )
      end
    end
  end
end
