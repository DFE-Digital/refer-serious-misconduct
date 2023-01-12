# frozen_string_literal: true

module PublicReferrals
  module Allegation
    class ConsiderationsController < Referrals::BaseController
      def edit
        @allegation_considerations_form =
          Referrals::Allegation::ConsiderationsForm.new
      end

      def next_path
        public_referral_allegation_considerations_path(current_referral)
      end
      helper_method :next_path

      def update_path
        public_referral_allegation_considerations_path(current_referral)
      end
      helper_method :update_path

      def back_link
        edit_public_referral_path(current_referral)
      end
      helper_method :back_link
    end
  end
end
