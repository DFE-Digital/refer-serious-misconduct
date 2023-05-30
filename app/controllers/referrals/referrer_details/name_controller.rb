module Referrals
  module ReferrerDetails
    class NameController < Referrals::BaseController
      def edit
        @form = Referrals::ReferrerDetails::NameForm.new(referral: current_referral)
      end

      def update
        @form =
          Referrals::ReferrerDetails::NameForm.new(name_params.merge(referral: current_referral))
        if @form.save
          redirect_to @form.next_path
        else
          render :edit
        end
      end

      private

      def name_params
        params.require(:referrals_referrer_details_name_form).permit(:first_name, :last_name)
      end
    end
  end
end
