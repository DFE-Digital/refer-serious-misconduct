module Referrals
  module TeacherRole
    class TeachingLocationController < Referrals::BaseController
      def edit
        @teaching_location_form =
          TeachingLocationForm.new(
            teaching_location_known: current_referral.teaching_location_known,
            teaching_organisation_name:
              current_referral.teaching_organisation_name,
            teaching_address_line_1: current_referral.teaching_address_line_1,
            teaching_address_line_2: current_referral.teaching_address_line_2,
            teaching_town_or_city: current_referral.teaching_town_or_city,
            teaching_postcode: current_referral.teaching_postcode
          )
      end

      def update
        @teaching_location_form =
          TeachingLocationForm.new(
            teaching_location_params.merge(referral: current_referral)
          )

        if @teaching_location_form.save
          redirect_to next_page
        else
          render :edit
        end
      end

      private

      def teaching_location_params
        params.require(:referrals_teacher_role_teaching_location_form).permit(
          :teaching_location_known,
          :teaching_organisation_name,
          :teaching_address_line_1,
          :teaching_address_line_2,
          :teaching_town_or_city,
          :teaching_postcode
        )
      end

      def next_path
        edit_referral_teacher_role_check_answers_path(current_referral)
      end
    end
  end
end
