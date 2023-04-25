module Referrals
  module TeacherRole
    class JobTitleController < Referrals::BaseController
      def edit
        @job_title_form = JobTitleForm.new(job_title: current_referral.job_title)
      end

      def update
        @job_title_form = JobTitleForm.new(job_title_params.merge(referral: current_referral))

        if @job_title_form.save
          redirect_to @job_title_form.next_path
        else
          render :edit
        end
      end

      private

      def job_title_params
        params.require(:referrals_teacher_role_job_title_form).permit(:job_title)
      end
    end
  end
end
