module Referrals
  module TeacherRole
    class ReasonLeavingRoleController < Referrals::BaseController
      def edit
        @reason_leaving_role_form =
          ReasonLeavingRoleForm.new(reason_leaving_role: current_referral.reason_leaving_role)
      end

      def update
        @reason_leaving_role_form =
          ReasonLeavingRoleForm.new(reason_leaving_role_params.merge(referral: current_referral))

        if @reason_leaving_role_form.save
          redirect_to @reason_leaving_role_form.next_path
        else
          render :edit
        end
      end

      private

      def reason_leaving_role_params
        params.require(:referrals_teacher_role_reason_leaving_role_form).permit(
          :reason_leaving_role
        )
      end
    end
  end
end
