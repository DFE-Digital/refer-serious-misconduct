module Referrals
  module TeacherRole
    class SameOrganisationController < Referrals::BaseController
      def edit
        @same_organisation_form =
          SameOrganisationForm.new(
            same_organisation: current_referral.same_organisation
          )
      end

      def update
        @same_organisation_form =
          SameOrganisationForm.new(
            same_organisation_params.merge(referral: current_referral)
          )

        if @same_organisation_form.save
          redirect_to next_page
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

      def next_path
        if current_referral.same_organisation?
          edit_referral_teacher_role_start_date_path(current_referral)
        else
          edit_referral_teacher_role_organisation_address_known_path(
            current_referral
          )
        end
      end

      def next_page
        if @same_organisation_form.referral.saved_changes? &&
             !current_referral.same_organisation
          return next_path
        end

        super
      end
    end
  end
end
