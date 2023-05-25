module Referrals
  module TeacherPersonalDetails
    class NiNumberController < Referrals::BaseController
      def edit
        @ni_number_form =
          NiNumberForm.new(
            ni_number: current_referral.ni_number,
            ni_number_known: current_referral.ni_number_known
          )
      end

      def update
        @ni_number_form = NiNumberForm.new(ni_number_form_params.merge(referral: current_referral))
        if @ni_number_form.save
          redirect_to @ni_number_form.next_path
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
