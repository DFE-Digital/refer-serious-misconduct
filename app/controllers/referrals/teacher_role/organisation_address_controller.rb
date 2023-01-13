module Referrals
  module TeacherRole
    class OrganisationAddressController < Referrals::BaseController
      def edit
        @organisation_address_form =
          OrganisationAddressForm.new(
            organisation_name: current_referral.organisation_name,
            organisation_address_line_1:
              current_referral.organisation_address_line_1,
            organisation_address_line_2:
              current_referral.organisation_address_line_2,
            organisation_town_or_city:
              current_referral.organisation_town_or_city,
            organisation_postcode: current_referral.organisation_postcode
          )
      end

      def update
        @organisation_address_form =
          OrganisationAddressForm.new(
            organisation_address_params.merge(referral: current_referral)
          )

        if @organisation_address_form.save
          redirect_to next_page
        else
          render :edit
        end
      end

      private

      def organisation_address_params
        params.require(
          :referrals_teacher_role_organisation_address_form
        ).permit(
          :organisation_name,
          :organisation_address_line_1,
          :organisation_address_line_2,
          :organisation_town_or_city,
          :organisation_postcode
        )
      end

      def next_path
        edit_referral_teacher_role_start_date_path(current_referral)
      end

      def update_path
        referral_teacher_role_organisation_address_path(current_referral)
      end
      helper_method :update_path

      def back_link
        edit_referral_teacher_role_organisation_address_known_path(
          current_referral
        )
      end
      helper_method :back_link
    end
  end
end
