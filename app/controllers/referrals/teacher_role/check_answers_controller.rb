module Referrals
  module TeacherRole
    class CheckAnswersController < Referrals::BaseController
      def edit
        @teacher_role_check_answers_form =
          CheckAnswersForm.new(teacher_role_complete: current_referral.teacher_role_complete)
      end

      def update
        @teacher_role_check_answers_form =
          CheckAnswersForm.new(teacher_role_check_answers_form_params.merge(referral: current_referral))
        if @teacher_role_check_answers_form.save
          redirect_to next_page
        else
          render :edit
        end
      end

      private

      def teacher_role_check_answers_form_params
        params.require(:referrals_teacher_role_check_answers_form).permit(:teacher_role_complete)
      end

      def next_path
        [:edit, current_referral.routing_scope, current_referral]
      end
    end
  end
end
