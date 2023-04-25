module Referrals
  module TeacherRole
    class WorkLocationKnownController < Referrals::BaseController
      def edit
        @work_location_known_form =
          WorkLocationKnownForm.new(work_location_known: current_referral.work_location_known)
      end

      def update
        @work_location_known_form =
          WorkLocationKnownForm.new(work_location_known_params.merge(referral: current_referral))

        if @work_location_known_form.save
          redirect_to @work_location_known_form.next_path
        else
          render :edit
        end
      end

      private

      def work_location_known_params
        params.require(:referrals_teacher_role_work_location_known_form).permit(
          :work_location_known
        )
      end
    end
  end
end
