module Referrals
  module TeacherContactDetails
    class CheckAnswersController < Referrals::BaseController
      def edit
        @form =
          CheckAnswersForm.new(
            referral: current_referral,
            contact_details_complete: current_referral.contact_details_complete
          )
      end

      def update
        @form =
          CheckAnswersForm.new(
            contact_details_check_answers_form_params.merge(referral: current_referral)
          )
        if @form.save
          redirect_to [:edit, current_referral.routing_scope, current_referral]
        else
          render :edit
        end
      end

      private

      def contact_details_check_answers_form_params
        params.require(:referrals_teacher_contact_details_check_answers_form).permit(
          :contact_details_complete
        )
      end
    end
  end
end
