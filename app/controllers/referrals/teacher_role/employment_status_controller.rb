module Referrals
  module TeacherRole
    class EmploymentStatusController < Referrals::BaseController
      def edit
        @form =
          EmploymentStatusForm.new(
            referral: current_referral,
            employment_status: current_referral.employment_status
          )
      end

      def update
        @form = EmploymentStatusForm.new(employment_status_params.merge(referral: current_referral))

        if @form.save
          redirect_to @form.next_path
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
