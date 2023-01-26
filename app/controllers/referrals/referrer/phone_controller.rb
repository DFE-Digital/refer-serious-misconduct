module Referrals
  module Referrer
    class PhoneController < Referrals::BaseController
      def edit
        @referrer_phone_form =
          Referrals::Referrer::PhoneForm.new(referral: current_referral)
      end

      def update
        @referrer_phone_form =
          Referrals::Referrer::PhoneForm.new(
            referrer_phone_form_params.merge(referral: current_referral)
          )
        if @referrer_phone_form.save
          redirect_to next_page
        else
          render :edit
        end
      end

      private

      def referrer_phone_form_params
        params.require(:referrals_referrer_phone_form).permit(:phone)
      end

      def next_path
        [
          :edit,
          current_referral.routing_scope,
          current_referral,
          :referrer,
          :check_answers
        ]
      end

      def previous_path
        polymorphic_path(
          [
            :edit,
            current_referral.routing_scope,
            current_referral,
            :referrer_job_title
          ]
        )
      end
      helper_method :previous_path
    end
  end
end
