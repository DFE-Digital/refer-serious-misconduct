module Referrals
  module TeacherRole
    class DutiesController < Referrals::BaseController
      def edit
        @duties_form =
          DutiesForm.new(
            referral: current_referral,
            duties_details: current_referral.duties_details,
            duties_format: current_referral.duties_format,
            duties_upload: current_referral.duties_upload
          )
      end

      def update
        @duties_form =
          DutiesForm.new(duties_params.merge(referral: current_referral))

        if @duties_form.save
          redirect_to referrals_edit_teacher_role_check_answers_path(
                        current_referral
                      )
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
    end
  end
end