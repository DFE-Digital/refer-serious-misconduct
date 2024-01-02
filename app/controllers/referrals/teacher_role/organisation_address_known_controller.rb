module Referrals
  module TeacherRole
    class OrganisationAddressKnownController < Referrals::BaseController
      def edit
        @form =
          OrganisationAddressKnownForm.new(
            referral: current_referral,
            changing:,
            organisation_address_known: current_referral.organisation_address_known,
          )
      end

      def update
        @form =
          OrganisationAddressKnownForm.new(
            organisation_address_known_params.merge(
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

      def organisation_address_known_params
        params.require(:referrals_teacher_role_organisation_address_known_form).permit(
          :organisation_address_known
        )
      end

      def previous_path
        polymorphic_path(
          [
            :edit,
            current_referral.routing_scope,
            current_referral,
            :teacher_role,
            :same_organisation
          ]
        )
      end
      helper_method :previous_path
    end
  end
end
