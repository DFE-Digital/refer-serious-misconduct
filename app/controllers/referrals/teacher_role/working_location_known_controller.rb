module Referrals
  module TeacherRole
    class WorkingLocationKnownController < Referrals::BaseController
      def edit
        @working_location_known_form =
          WorkingLocationKnownForm.new(
            working_location_known: current_referral.working_location_known
          )
      end

      def update
        @working_location_known_form =
          WorkingLocationKnownForm.new(
            working_location_known_params.merge(referral: current_referral)
          )

        if @working_location_known_form.save
          redirect_to next_page
        else
          render :edit
        end
      end

      private

      def working_location_known_params
        params.require(
          :referrals_teacher_role_working_location_known_form
        ).permit(:working_location_known)
      end

      def next_path
        if current_referral.working_location_known?
          edit_referral_teacher_role_teaching_location_path(current_referral)
        else
          edit_referral_teacher_role_check_answers_path(current_referral)
        end
      end

      def next_page
        if @working_location_known_form.referral.saved_changes? &&
             current_referral.working_location_known
          return next_path
        end

        super
      end
    end
  end
end
