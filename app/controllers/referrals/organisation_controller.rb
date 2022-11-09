module Referrals
  class OrganisationController < BaseController
    def show
      @organisation =
        current_referral.organisation || current_referral.build_organisation
      @organisation_form = OrganisationForm.new(referral: current_referral)
    end

    def update
      @organisation_form =
        OrganisationForm.new(
          complete: organisation_params[:complete],
          referral: current_referral
        )

      if @organisation_form.save
        redirect_to edit_referral_path(current_referral)
      else
        @organisation = current_referral.organisation
        render :show
      end
    end

    private

    def organisation_params
      params.require(:organisation_form).permit(:complete)
    end
  end
end
