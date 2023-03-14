module Referrals
  module Referrer
    class CheckAnswersForm
      include ReferralFormSection

      attr_accessor :referrer
      attr_reader :complete

      validates :complete, inclusion: { in: [true, false] }
      validates :referrer, presence: true

      def complete=(value)
        @complete = ActiveModel::Type::Boolean.new.cast(value)
      end

      def save
        return false unless valid?

        referrer.update(complete:)
      end
    end
  end
end
