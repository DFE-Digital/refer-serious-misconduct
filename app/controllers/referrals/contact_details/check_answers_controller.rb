module Referrals
  module ContactDetails
    class CheckAnswersController < Referrals::BaseController
      def edit
        @contact_details_check_answers_form =
          CheckAnswersForm.new(
            contact_details_complete: current_referral.contact_details_complete
          )
      end

      def update
        @contact_details_check_answers_form =
          CheckAnswersForm.new(
            contact_details_check_answers_form_params.merge(
              referral: current_referral
            )
          )
        if @contact_details_check_answers_form.save
          redirect_to edit_referral_path(current_referral)
        else
          render :edit
        end
      end

      private

      def contact_details_check_answers_form_params
        params.require(:referrals_contact_details_check_answers_form).permit(
          :contact_details_complete
        )
      end
    end
  end
end
