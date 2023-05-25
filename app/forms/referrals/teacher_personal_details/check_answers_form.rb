# frozen_string_literal: true
module Referrals
  module TeacherPersonalDetails
    class CheckAnswersForm < FormItem
      validates :personal_details_complete, inclusion: { in: [true, false] }

      attr_referral :personal_details_complete

      def save
        referral.update(personal_details_complete:) if valid?
      end
    end
  end
end
