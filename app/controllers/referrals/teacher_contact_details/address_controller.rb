module Referrals
  module TeacherContactDetails
    class AddressController < Referrals::BaseController
      def edit
        @contact_details_address_form =
          AddressForm.new(
            address_line_1: current_referral.address_line_1,
            address_line_2: current_referral.address_line_2,
            town_or_city: current_referral.town_or_city,
            postcode: current_referral.postcode,
            country: current_referral.country
          )
      end

      def update
        @contact_details_address_form =
          AddressForm.new(contact_details_address_form_params.merge(referral: current_referral))
        if @contact_details_address_form.save
          redirect_to @contact_details_address_form.next_path
        else
          render :edit
        end
      end

      private

      def contact_details_address_form_params
        params.require(:referrals_teacher_contact_details_address_form).permit(
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
