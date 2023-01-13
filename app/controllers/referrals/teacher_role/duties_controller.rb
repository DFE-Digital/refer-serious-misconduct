module Referrals
  module TeacherRole
    class DutiesController < Referrals::BaseController
      def edit
        @duties_form =
          DutiesForm.new(
            duties_details: current_referral.duties_details,
            duties_format: current_referral.duties_format,
            duties_upload: current_referral.duties_upload
          )
      end

      def update
        @duties_form =
          DutiesForm.new(duties_params.merge(referral: current_referral))

        if @duties_form.save
          redirect_to next_page
        else
          render :edit
        end
      end

      private

      def duties_params
        params.require(:referrals_teacher_role_duties_form).permit(
          :duties_format,
          :duties_details,
          :duties_upload
        )
      end

      def next_path
        edit_referral_teacher_role_same_organisation_path(current_referral)
      end

      def update_path
        referral_teacher_role_duties_path(current_referral)
      end
      helper_method :update_path

      def back_link
        edit_referral_teacher_role_job_title_path(current_referral)
      end
      helper_method :back_link
    end
  end
end
