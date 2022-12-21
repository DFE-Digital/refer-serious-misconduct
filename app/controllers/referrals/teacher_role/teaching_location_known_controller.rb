module Referrals
  module TeacherRole
    class TeachingLocationKnownController < Referrals::BaseController
      def edit
        @teaching_location_known_form =
          TeachingLocationKnownForm.new(
            teaching_location_known: current_referral.teaching_location_known
          )
      end

      def update
        @teaching_location_known_form =
          TeachingLocationKnownForm.new(
            teaching_location_known_params.merge(referral: current_referral)
          )

        if @teaching_location_known_form.save
          redirect_to next_page
        else
          render :edit
        end
      end

      private

      def teaching_location_known_params
        params.require(
          :referrals_teacher_role_teaching_location_known_form
        ).permit(:teaching_location_known)
      end

      def next_path
        if current_referral.teaching_location_known?
          edit_referral_teacher_role_teaching_location_path(current_referral)
        else
          edit_referral_teacher_role_check_answers_path(current_referral)
        end
      end

      def next_page
        if @teaching_location_known_form.referral.saved_changes? &&
             current_referral.teaching_location_known
          return next_path
        end

        super
      end
    end
  end
end
