module Referrals
  module PreviousMisconduct
    class CheckAnswersForm < FormItem
      attr_referral :previous_misconduct_complete

      validates :previous_misconduct_complete, inclusion: { in: [true, false] }

      def save
        return false unless valid?

        referral.update(previous_misconduct_complete:)
      end
    end
  end
end
