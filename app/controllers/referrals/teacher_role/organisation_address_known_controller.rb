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
          redirect_to next_page
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

      def next_path
        if current_referral.organisation_address_known?
          [
            :edit,
            current_referral.routing_scope,
            current_referral,
            :teacher_role,
            :organisation_address
          ]
        else
          [:edit, current_referral.routing_scope, current_referral, :teacher_role, :start_date]
        end
      end

      def next_page
        if @organisation_address_known_form.referral.saved_changes? &&
             current_referral.organisation_address_known
          return next_path
        end

        super
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
