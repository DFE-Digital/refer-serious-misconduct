module Referrals
  module TeacherPersonalDetails
    class NiNumberController < Referrals::BaseController
      def edit
        @form =
          NiNumberForm.new(
            referral: current_referral,
            changing:,
            ni_number: current_referral.ni_number,
            ni_number_known: current_referral.ni_number_known
          )
      end

      def update
        @form = NiNumberForm.new(
          ni_number_form_params.merge(
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

      def ni_number_form_params
        params.require(:referrals_teacher_personal_details_ni_number_form).permit(
          :ni_number,
          :ni_number_known
        )
      end
    end
  end
end
