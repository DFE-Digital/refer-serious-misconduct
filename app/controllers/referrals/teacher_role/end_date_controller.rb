module Referrals
  module TeacherRole
    class EndDateController < Referrals::BaseController
      def edit
        @form =
          EndDateForm.new(
            referral: current_referral,
            role_end_date_known: current_referral.role_end_date_known,
            role_end_date: current_referral.role_end_date
          )
      end

      def update
        @form =
          EndDateForm.new(
            role_params.merge(date_params: end_date_params, referral: current_referral)
          )

        if @form.save
          redirect_to @form.next_path
        else
          render :edit
        end
      end

      private

      def role_params
        params.require(:referrals_teacher_role_end_date_form).permit(:role_end_date_known)
      end

      def end_date_params
        params.require(:referrals_teacher_role_end_date_form).permit(
          "role_end_date(3i)",
          "role_end_date(2i)",
          "role_end_date(1i)"
        )
      end
    end
  end
end
