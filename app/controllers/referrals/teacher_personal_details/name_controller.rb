module Referrals
  module TeacherPersonalDetails
    class NameController < Referrals::BaseController
      def edit
        @form =
          NameForm.new(
            referral: current_referral,
            changing:,
            first_name: current_referral.first_name,
            last_name: current_referral.last_name,
            name_has_changed: current_referral.name_has_changed,
            previous_name: current_referral.previous_name
          )
      end

      def update
        @form = NameForm.new(
          name_params.merge(
            referral: current_referral,
            changing:,
          )
        )

        if @form.save
          redirect_to @form.next_path
        else
          render :edit
        end
      end

      private

      def name_params
        params.require(:referrals_teacher_personal_details_name_form).permit(
          :first_name,
          :last_name,
          :name_has_changed,
          :previous_name
        )
      end
    end
  end
end
