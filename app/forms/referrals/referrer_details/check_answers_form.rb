module Referrals
  module Referrer
    class CheckAnswersForm < FormItem
      attr_accessor :referrer
      attr_referrer :complete

      validates :complete, inclusion: { in: [true, false] }
      validates :referrer, presence: true

      def save
        return false unless valid?

        referrer.update(complete:)
      end
    end
  end
end
