module Referrals
  module TeacherRole
    class CheckAnswersController < Referrals::BaseController
      def edit
        @teacher_role_check_answers_form =
          CheckAnswersForm.new(
            teacher_role_complete: current_referral.teacher_role_complete
          )
      end

      def update
        @teacher_role_check_answers_form =
          CheckAnswersForm.new(
            teacher_role_check_answers_form_params.merge(
              referral: current_referral
            )
          )
        if @teacher_role_check_answers_form.save
          redirect_to next_page
        else
          render :edit
        end
      end

      private

      def teacher_role_check_answers_form_params
        params.require(:referrals_teacher_role_check_answers_form).permit(
          :teacher_role_complete
        )
      end

      def next_path
        edit_referral_path(current_referral)
      end

      def update_path
        referral_teacher_role_check_answers_path(current_referral)
      end
      helper_method :update_path

      def back_link
        edit_referral_path(current_referral)
      end
      helper_method :back_link
    end
  end
end
