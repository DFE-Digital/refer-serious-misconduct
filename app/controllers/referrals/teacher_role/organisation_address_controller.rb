module Referrals
  module TeacherRole
    class OrganisationAddressController < Referrals::BaseController
      def edit
        @organisation_address_form =
          OrganisationAddressForm.new(
            organisation_name: current_referral.organisation_name,
            organisation_address_line_1: current_referral.organisation_address_line_1,
            organisation_address_line_2: current_referral.organisation_address_line_2,
            organisation_town_or_city: current_referral.organisation_town_or_city,
            organisation_postcode: current_referral.organisation_postcode
          )
      end

      def update
        @organisation_address_form =
          OrganisationAddressForm.new(organisation_address_params.merge(referral: current_referral))

        if @organisation_address_form.save
          redirect_to next_page
        else
          render :edit
        end
      end

      private

      def organisation_address_params
        params.require(:referrals_teacher_role_organisation_address_form).permit(
          :organisation_name,
          :organisation_address_line_1,
          :organisation_address_line_2,
          :organisation_town_or_city,
          :organisation_postcode
        )
      end

      def next_path
        [:edit, current_referral.routing_scope, current_referral, :teacher_role, :start_date]
      end
    end
  end
end
