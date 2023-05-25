module Referrals
  module TeacherPersonalDetails
    class TrnController < Referrals::BaseController
      def edit
        @personal_details_trn_form =
          TrnForm.new(trn: current_referral.trn, trn_known: current_referral.trn_known)
      end

      def update
        @personal_details_trn_form = TrnForm.new(trn_params.merge(referral: current_referral))

        if @personal_details_trn_form.save
          redirect_to @personal_details_trn_form.next_path
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
