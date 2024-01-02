module Referrals
  module TeacherRole
    class SameOrganisationController < Referrals::BaseController
      def edit
        @form =
          SameOrganisationForm.new(
            referral: current_referral,
            changing:,
            same_organisation: current_referral.same_organisation
          )
      end

      def update
        @form = SameOrganisationForm.new(
          same_organisation_params.merge(
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

      def same_organisation_params
        params.require(:referrals_teacher_role_same_organisation_form).permit(:same_organisation)
      end
    end
  end
end
