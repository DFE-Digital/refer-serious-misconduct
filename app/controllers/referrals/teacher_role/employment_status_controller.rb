module Referrals
  module TeacherRole
    class EmploymentStatusController < Referrals::BaseController
      def edit
        @employment_status_form =
          EmploymentStatusForm.new(
            employment_status: current_referral.employment_status
          )
      end

      def update
        @employment_status_form =
          EmploymentStatusForm.new(
            employment_status_params.merge(referral: current_referral)
          )

        if @employment_status_form.save
          redirect_to next_page
        else
          render :edit
        end
      end

      private

      def employment_status_params
        params.require(:referrals_teacher_role_employment_status_form).permit(
          :employment_status
        )
      end

      def next_path
        if current_referral.left_role?
          edit_referral_teacher_role_end_date_path(current_referral)
        else
          edit_referral_teacher_role_check_answers_path(current_referral)
        end
      end

      def next_page
        if @employment_status_form.referral.saved_changes? &&
             current_referral.left_role?
          return next_path
        end

        super
      end
    end
  end
end
