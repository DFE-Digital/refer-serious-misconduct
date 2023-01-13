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
            role_params.merge(
              date_params: start_date_params,
              referral: current_referral
            )
          )

        if @role_start_date_form.save
          redirect_to next_page
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

      def next_path
        edit_referral_teacher_role_employment_status_path(current_referral)
      end

      def update_path
        referral_teacher_role_start_date_path(current_referral)
      end
      helper_method :update_path

      def back_link
        edit_referral_teacher_role_same_organisation_path(current_referral)
      end
      helper_method :back_link
    end
  end
end
