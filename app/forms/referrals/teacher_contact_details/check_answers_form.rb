module Referrals
  module ContactDetails
    class CheckAnswersForm < FormItem
      attr_referral :contact_details_complete

      validates :contact_details_complete, inclusion: { in: [true, false] }

      def save
        return false unless valid?

        referral.update(contact_details_complete:)
      end
    end
  end
end
