module Referrals
  module TeacherContactDetails
    class AddressKnownController < Referrals::BaseController
      def edit
        @form =
          AddressKnownForm.new(
            referral: current_referral,
            address_known: current_referral.address_known
          )
      end

      def update
        @form =
          AddressKnownForm.new(
            contact_details_address_known_form_params.merge(referral: current_referral)
          )
        if @form.save
          redirect_to @form.next_path
        else
          render :edit
        end
      end

      private

      def contact_details_address_known_form_params
        params.require(:referrals_teacher_contact_details_address_known_form).permit(:address_known)
      end
    end
  end
end
