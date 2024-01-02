module Referrals
  module TeacherContactDetails
    class AddressController < Referrals::BaseController
      def edit
        @form =
          AddressForm.new(
            referral: current_referral,
            changing:,
            address_line_1: current_referral.address_line_1,
            address_line_2: current_referral.address_line_2,
            town_or_city: current_referral.town_or_city,
            postcode: current_referral.postcode,
            country: current_referral.country
          )
      end

      def update
        @form =
          AddressForm.new(
            contact_details_address_form_params.merge(
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
