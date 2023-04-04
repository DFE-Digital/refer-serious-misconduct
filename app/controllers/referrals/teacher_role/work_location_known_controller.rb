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
          redirect_to next_page
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

      def next_path
        if current_referral.work_location_known?
          [:edit, current_referral.routing_scope, current_referral, :teacher_role, :work_location]
        else
          [:edit, current_referral.routing_scope, current_referral, :teacher_role, :check_answers]
        end
      end

      def next_page
        if @work_location_known_form.referral.saved_changes? && current_referral.work_location_known
          return next_path
        end

        super
      end
    end
  end
end
