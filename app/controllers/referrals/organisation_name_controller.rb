module Referrals
  class OrganisationNameController < BaseController
    def edit
      @organisation_name_form =
        OrganisationNameForm.new(referral: current_referral)
    end

    def update
      @organisation_name_form =
        OrganisationNameForm.new(
          organisation_name_form_params.merge(referral: current_referral)
        )
      if @organisation_name_form.save
        redirect_to next_page
      else
        render :edit
      end
    end

    private

    def next_path
      edit_referral_organisation_address_path(current_referral)
    end

    def organisation_name_form_params
      params.require(:organisation_name_form).permit(:name)
    end
  end
end
