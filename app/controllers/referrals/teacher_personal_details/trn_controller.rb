module Referrals
  module TeacherPersonalDetails
    class TrnController < Referrals::BaseController
      def edit
        @form =
          TrnForm.new(
            referral: current_referral,
            trn: current_referral.trn,
            trn_known: current_referral.trn_known
          )
      end

      def update
        @form = TrnForm.new(trn_params.merge(referral: current_referral))

        if @form.save
          redirect_to @form.next_path
        else
          render :edit
        end
      end

      private

      def trn_params
        params.require(:referrals_teacher_personal_details_trn_form).permit(:trn_known, :trn)
      end
    end
  end
end
