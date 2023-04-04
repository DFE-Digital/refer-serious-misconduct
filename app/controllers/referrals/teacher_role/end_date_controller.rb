module Referrals
  module TeacherRole
    class EndDateController < Referrals::BaseController
      def edit
        @role_end_date_form =
          EndDateForm.new(
            role_end_date_known: current_referral.role_end_date_known,
            role_end_date: current_referral.role_end_date
          )
      end

      def update
        @role_end_date_form =
          EndDateForm.new(
            role_params.merge(date_params: end_date_params, referral: current_referral)
          )

        if @role_end_date_form.save
          redirect_to next_page
        else
          render :edit
        end
      end

      private

      def role_params
        params.require(:referrals_teacher_role_end_date_form).permit(:role_end_date_known)
      end

      def end_date_params
        params.require(:referrals_teacher_role_end_date_form).permit(
          "role_end_date(3i)",
          "role_end_date(2i)",
          "role_end_date(1i)"
        )
      end

      def next_path
        if current_referral.left_role?
          [
            :edit,
            current_referral.routing_scope,
            current_referral,
            :teacher_role,
            :reason_leaving_role
          ]
        else
          [:edit, current_referral.routing_scope, current_referral, :teacher_role, :check_answers]
        end
      end
    end
  end
end
