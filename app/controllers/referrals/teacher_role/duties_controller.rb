module Referrals
  module TeacherRole
    class DutiesController < Referrals::BaseController
      def edit
        @form =
          DutiesForm.new(
            referral: current_referral,
            duties_details: current_referral.duties_details,
            duties_format: current_referral.duties_format,
            duties_upload_file: current_referral.duties_upload_file
          )
      end

      def update
        @form = DutiesForm.new(duties_params.merge(referral: current_referral))

        if @form.save
          redirect_to @form.next_path
        else
          render :edit
        end
      end

      private

      def duties_params
        params.require(:referrals_teacher_role_duties_form).permit(
          :duties_format,
          :duties_details,
          :duties_upload_file
        )
      end
    end
  end
end
