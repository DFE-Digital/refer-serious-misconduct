module Referrals
  module ReferrerDetails
    class PhoneController < Referrals::BaseController
      def edit
        @form = Referrals::ReferrerDetails::PhoneForm.new(
          referral: current_referral,
          changing:,
        )
      end

      def update
        @form =
          Referrals::ReferrerDetails::PhoneForm.new(
            referrer_phone_form_params.merge(
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

      def referrer_phone_form_params
        params.require(:referrals_referrer_details_phone_form).permit(:phone)
      end

      def previous_path
        polymorphic_path(
          [:edit, current_referral.routing_scope, current_referral, :referrer_details_job_title]
        )
      end
      helper_method :previous_path
    end
  end
end
