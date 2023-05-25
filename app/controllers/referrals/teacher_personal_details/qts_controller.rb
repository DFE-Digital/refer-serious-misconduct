module Referrals
  module TeacherPersonalDetails
    class QtsController < Referrals::BaseController
      def edit
        @personal_details_qts_form = QtsForm.new(has_qts: current_referral.has_qts)
      end

      def update
        @personal_details_qts_form = QtsForm.new(qts_params.merge(referral: current_referral))

        if @personal_details_qts_form.save
          redirect_to @personal_details_qts_form.next_path
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
