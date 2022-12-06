module Referrals
  module TeacherRole
    class TeachingSomewhereElseController < Referrals::BaseController
      def edit
        @teaching_somewhere_else_form =
          TeachingSomewhereElseForm.new(
            teaching_somewhere_else: current_referral.teaching_somewhere_else
          )
      end

      def update
        @teaching_somewhere_else_form =
          TeachingSomewhereElseForm.new(
            teaching_somewhere_else_params.merge(referral: current_referral)
          )

        if @teaching_somewhere_else_form.save
          redirect_to next_page
        else
          render :edit
        end
      end

      private

      def teaching_somewhere_else_params
        params.require(
          :referrals_teacher_role_teaching_somewhere_else_form
        ).permit(:teaching_somewhere_else)
      end

      def next_path
        referrals_edit_teacher_role_check_answers_path(current_referral)
      end
    end
  end
end
