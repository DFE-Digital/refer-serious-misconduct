module Referrals
  module TeacherRole
    class CheckAnswersController < Referrals::BaseController
      def edit
        @form =
          CheckAnswersForm.new(
            referral: current_referral,
            teacher_role_complete: current_referral.teacher_role_complete
          )
      end

      def update
        @form =
          CheckAnswersForm.new(
            teacher_role_check_answers_form_params.merge(referral: current_referral)
          )
        if @form.save
          redirect_to @form.next_path
        else
          render :edit
        end
      end

      private

      def teacher_role_check_answers_form_params
        params.require(:referrals_teacher_role_check_answers_form).permit(:teacher_role_complete)
      end
    end
  end
end
