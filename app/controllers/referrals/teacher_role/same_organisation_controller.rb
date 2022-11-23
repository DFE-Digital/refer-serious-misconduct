module Referrals
  module TeacherRole
    class SameOrganisationController < Referrals::BaseController
      def edit
        @same_organisation_form =
          SameOrganisationForm.new(
            referral: current_referral,
            same_organisation: current_referral.same_organisation
          )
      end

      def update
        @same_organisation_form =
          SameOrganisationForm.new(
            same_organisation_params.merge(referral: current_referral)
          )

        if @same_organisation_form.save
          redirect_to edit_referral_path(current_referral)
        else
          render :edit
        end
      end

      private

      def same_organisation_params
        params.require(:referrals_teacher_role_same_organisation_form).permit(
          :same_organisation
        )
      end
    end
  end
end
