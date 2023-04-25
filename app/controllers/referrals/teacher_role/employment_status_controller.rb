module Referrals
  module TeacherRole
    class EmploymentStatusController < Referrals::BaseController
      def edit
        @employment_status_form =
          EmploymentStatusForm.new(employment_status: current_referral.employment_status)
      end

      def update
        @employment_status_form =
          EmploymentStatusForm.new(employment_status_params.merge(referral: current_referral))

        if @employment_status_form.save
          redirect_to @employment_status_form.next_path
        else
          render :edit
        end
      end

      private

      def employment_status_params
        params.require(:referrals_teacher_role_employment_status_form).permit(:employment_status)
      end
    end
  end
end
