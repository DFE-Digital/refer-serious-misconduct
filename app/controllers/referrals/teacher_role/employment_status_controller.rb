module Referrals
  module TeacherRole
    class EmploymentStatusController < Referrals::BaseController
      def edit
        @employment_status_form =
          EmploymentStatusForm.new(
            referral: current_referral,
            employment_status: current_referral.employment_status,
            role_end_date: current_referral.role_end_date,
            reason_leaving_role: current_referral.reason_leaving_role
          )
      end

      def update
        @employment_status_form =
          EmploymentStatusForm.new(
            employment_status_params.merge(referral: current_referral)
          )

        if @employment_status_form.save(end_date_params)
          redirect_to referrals_edit_teacher_job_title_path(current_referral)
        else
          render :edit
        end
      end

      private

      def employment_status_params
        params.require(:referrals_teacher_role_employment_status_form).permit(
          :employment_status,
          :reason_leaving_role
        )
      end

      def end_date_params
        params.require(:referrals_teacher_role_employment_status_form).permit(
          "role_end_date(3i)",
          "role_end_date(2i)",
          "role_end_date(1i)"
        )
      end
    end
  end
end
