module Referrals
  module PreviousMisconduct
    class CheckAnswersForm
      include ActiveModel::Model

      attr_accessor :referral
      attr_reader :previous_misconduct_complete

      validates :referral, presence: true
      validates :previous_misconduct_complete, inclusion: { in: [true, false] }

      def previous_misconduct_complete=(value)
        @previous_misconduct_complete =
          ActiveModel::Type::Boolean.new.cast(value)
      end

      def save
        return false unless valid?

        referral.update(previous_misconduct_complete:)
      end
    end
  end
end
