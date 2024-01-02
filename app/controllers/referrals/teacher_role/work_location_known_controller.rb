module Referrals
  module TeacherRole
    class WorkLocationKnownController < Referrals::BaseController
      def edit
        @form =
          WorkLocationKnownForm.new(
            referral: current_referral,
            changing:,
            work_location_known: current_referral.work_location_known
          )
      end

      def update
        @form =
          WorkLocationKnownForm.new(work_location_known_params.merge(referral: current_referral))

        if @form.save
          redirect_to @form.next_path
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
