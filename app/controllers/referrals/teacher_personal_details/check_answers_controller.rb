module Referrals
  module TeacherPersonalDetails
    class CheckAnswersController < Referrals::BaseController
      def edit
        @form =
          CheckAnswersForm.new(
            referral: current_referral,
            personal_details_complete: current_referral.personal_details_complete
          )
      end

      def update
        @form = CheckAnswersForm.new(check_answers_params.merge(referral: current_referral))

        if @form.save
          redirect_to @form.next_path
        else
          render :edit
        end
      end

      private

      def check_answers_params
        params.fetch(:referrals_teacher_personal_details_check_answers_form, {}).permit(
          :personal_details_complete
        )
      end
    end
  end
end
