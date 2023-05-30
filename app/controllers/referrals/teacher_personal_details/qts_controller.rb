module Referrals
  module TeacherPersonalDetails
    class QtsController < Referrals::BaseController
      def edit
        @form = QtsForm.new(referral: current_referral, has_qts: current_referral.has_qts)
      end

      def update
        @form = QtsForm.new(qts_params.merge(referral: current_referral))

        if @form.save
          redirect_to @form.next_path
        else
          render :edit
        end
      end

      private

      def qts_params
        params.fetch(:referrals_teacher_personal_details_qts_form, {}).permit(:has_qts)
      end
    end
  end
end
