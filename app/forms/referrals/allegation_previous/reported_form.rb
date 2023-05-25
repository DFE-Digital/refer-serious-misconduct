module Referrals
  module AllegationPrevious
    class ReportedForm < FormItem
      attr_referral :previous_misconduct_reported

      validates :previous_misconduct_reported, inclusion: { in: %w[true false not_sure] }

      def save
        return false unless valid?

        referral.update(previous_misconduct_reported:)
      end
    end
  end
end
