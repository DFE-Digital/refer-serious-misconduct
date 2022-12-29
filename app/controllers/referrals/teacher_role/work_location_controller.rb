module Referrals
  module TeacherRole
    class WorkLocationController < Referrals::BaseController
      def edit
        @work_location_form =
          WorkLocationForm.new(
            work_organisation_name: current_referral.work_organisation_name,
            work_address_line_1: current_referral.work_address_line_1,
            work_address_line_2: current_referral.work_address_line_2,
            work_town_or_city: current_referral.work_town_or_city,
            work_postcode: current_referral.work_postcode
          )
      end

      def update
        @work_location_form =
          WorkLocationForm.new(
            work_location_params.merge(referral: current_referral)
          )

        if @work_location_form.save
          redirect_to next_page
        else
          render :edit
        end
      end

      private

      def work_location_params
        params.require(:referrals_teacher_role_work_location_form).permit(
          :work_organisation_name,
          :work_address_line_1,
          :work_address_line_2,
          :work_town_or_city,
          :work_postcode
        )
      end

      def next_path
        edit_referral_teacher_role_check_answers_path(current_referral)
      end
    end
  end
end
