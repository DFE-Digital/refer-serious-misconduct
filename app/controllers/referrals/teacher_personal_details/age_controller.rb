module Referrals
  module TeacherPersonalDetails
    class AgeController < Referrals::BaseController
      def edit
        @personal_details_age_form =
          AgeForm.new(
            age_known: current_referral.age_known,
            date_of_birth: current_referral.date_of_birth
          )
      end

      def update
        @personal_details_age_form =
          AgeForm.new(
            age_params.merge(date_params: date_of_birth_params, referral: current_referral)
          )

        if @personal_details_age_form.save
          redirect_to @personal_details_age_form.next_path
        else
          render :edit
        end
      end

      private

      def age_params
        params.require(:referrals_teacher_personal_details_age_form).permit(:age_known)
      end

      def date_of_birth_params
        params.require(:referrals_teacher_personal_details_age_form).permit(
          "date_of_birth(1i)",
          "date_of_birth(2i)",
          "date_of_birth(3i)"
        )
      end
    end
  end
end
