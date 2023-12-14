module Referrals
  module TeacherRole
    class WorkingSomewhereElseController < Referrals::BaseController
      def edit
        @form =
          WorkingSomewhereElseForm.new(
            referral: current_referral,
            changing:,
            working_somewhere_else: current_referral.working_somewhere_else
          )
      end

      def update
        @form =
          WorkingSomewhereElseForm.new(
            working_somewhere_else_params.merge(
              referral: current_referral,
              changing:,
            )
          )

        if @form.save
          redirect_to @form.next_path
        else
          render :edit
        end
      end

      private

      def working_somewhere_else_params
        params.require(:referrals_teacher_role_working_somewhere_else_form).permit(
          :working_somewhere_else
        )
      end
    end
  end
end
