module Referrals
  module ReferrerOrganisation
    class AddressController < BaseController
      def edit
        @form = AddressForm.new(
          referral: current_referral,
          changing:,
        )
      end

      def update
        @form = AddressForm.new(
          organisation_address_form_params.merge(
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

      def organisation_address_form_params
        params.require(:referrals_referrer_organisation_address_form).permit(
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
