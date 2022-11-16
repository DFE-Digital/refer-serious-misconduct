module Referrals
  module TeacherRole
    class StartDateController < Referrals::BaseController
      def edit
        @role_start_date_form =
          StartDateForm.new(
            referral: current_referral,
            role_start_date_known: current_referral.role_start_date_known,
            role_start_date: current_referral.role_start_date
          )
      end

      def update
        @role_start_date_form =
          StartDateForm.new(role_params.merge(referral: current_referral))

        if @role_start_date_form.save(start_date_params)
          # TODO: redirect to job end date page
          redirect_to edit_referral_path(current_referral)
        else
          render :edit
        end
      end

      private

      def role_params
        params.require(:referrals_teacher_role_start_date_form).permit(
          :role_start_date_known
        )
      end

      def start_date_params
        params.require(:referrals_teacher_role_start_date_form).permit(
          "role_start_date(3i)",
          "role_start_date(2i)",
          "role_start_date(1i)"
        )
      end
    end
  end
end
