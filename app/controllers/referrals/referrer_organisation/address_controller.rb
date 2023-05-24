module Referrals
  module Organisation
    class AddressController < BaseController
      def edit
        @organisation_address_form = AddressForm.new(referral: current_referral)
      end

      def update
        @organisation_address_form =
          AddressForm.new(organisation_address_form_params.merge(referral: current_referral))
        if @organisation_address_form.save
          redirect_to @organisation_address_form.next_path
        else
          render :edit
        end
      end

      private

      def organisation_address_form_params
        params.require(:referrals_organisation_address_form).permit(
          :city,
          :name,
          :postcode,
          :street_1,
          :street_2
        )
      end
    end
  end
end
