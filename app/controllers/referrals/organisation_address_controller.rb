module Referrals
  class OrganisationAddressController < BaseController
    def edit
      @organisation_address_form =
        OrganisationAddressForm.new(referral: current_referral)
    end

    def update
      @organisation_address_form =
        OrganisationAddressForm.new(
          organisation_address_form_params.merge(referral: current_referral)
        )
      if @organisation_address_form.save
        redirect_to next_page
      else
        render :edit
      end
    end

    private

    def organisation_address_form_params
      params.require(:organisation_address_form).permit(
        :street_1,
        :street_2,
        :city,
        :postcode
      )
    end

    def next_path
      referral_organisation_path(current_referral)
    end
  end
end
