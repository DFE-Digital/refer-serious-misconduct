module Referrals
  module TeacherRole
    class OrganisationAddressKnownController < Referrals::BaseController
      def edit
        @organisation_address_known_form =
          OrganisationAddressKnownForm.new(
            organisation_address_known: current_referral.organisation_address_known
          )
      end

      def update
        @organisation_address_known_form =
          OrganisationAddressKnownForm.new(
            organisation_address_known_params.merge(referral: current_referral)
          )

        if @organisation_address_known_form.save
          redirect_to @organisation_address_known_form.next_path
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

      def back_link
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
      helper_method :back_link
    end
  end
end
