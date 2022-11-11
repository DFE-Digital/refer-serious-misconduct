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
        redirect_to save_redirect_path
      else
        render :edit
      end
    end

    private

    def save_redirect_path
      if go_to_check_answers?
        return referral_organisation_path(current_referral)
      end

      edit_referral_organisation_address_path(current_referral)
    end

    def organisation_name_form_params
      params.require(:organisation_name_form).permit(:name)
    end
  end
end
