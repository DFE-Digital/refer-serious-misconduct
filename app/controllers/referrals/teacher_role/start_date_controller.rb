module Referrals
  module TeacherRole
    class StartDateController < Referrals::BaseController
      def edit
        @role_start_date_form =
          StartDateForm.new(
            role_start_date_known: current_referral.role_start_date_known,
            role_start_date: current_referral.role_start_date
          )
      end

      def update
        @role_start_date_form =
          StartDateForm.new(
            role_params.merge(date_params: start_date_params, referral: current_referral)
          )

        if @role_start_date_form.save
          redirect_to @role_start_date_form.next_path
        else
          render :edit
        end
      end

      private

      def role_params
        params.require(:referrals_teacher_role_start_date_form).permit(:role_start_date_known)
      end

      def start_date_params
        params.require(:referrals_teacher_role_start_date_form).permit(
          "role_start_date(3i)",
          "role_start_date(2i)",
          "role_start_date(1i)"
        )
      end

      def back_link
        polymorphic_path(
          [
            :edit,
            current_referral.routing_scope,
            current_referral,
            :teacher_role,
            :same_organisation
          ]
        )
      end
      helper_method :back_link
    end
  end
end
