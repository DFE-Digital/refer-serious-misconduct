module Referrals
  module TeacherRole
    class WorkLocationController < Referrals::BaseController
      def edit
        @form =
          WorkLocationForm.new(
            referral: current_referral,
            work_organisation_name: current_referral.work_organisation_name,
            work_address_line_1: current_referral.work_address_line_1,
            work_address_line_2: current_referral.work_address_line_2,
            work_town_or_city: current_referral.work_town_or_city,
            work_postcode: current_referral.work_postcode
          )
      end

      def update
        @form = WorkLocationForm.new(work_location_params.merge(referral: current_referral))

        if @form.save
          redirect_to @form.next_path
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
    end
  end
end
