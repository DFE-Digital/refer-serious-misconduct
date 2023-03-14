# frozen_string_literal: true
module Referrals
  module PersonalDetails
    class CheckAnswersForm
      include ReferralFormSection

      validates :personal_details_complete, inclusion: { in: [true, false] }

      attr_reader :personal_details_complete

      def personal_details_complete=(value)
        @personal_details_complete = ActiveModel::Type::Boolean.new.cast(value)
      end

      def save
        referral.update(personal_details_complete:) if valid?
      end
    end
  end
end
