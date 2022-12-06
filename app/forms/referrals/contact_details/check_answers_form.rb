module Referrals
  module ContactDetails
    class CheckAnswersForm
      include ActiveModel::Model

      attr_accessor :referral
      attr_reader :contact_details_complete

      validates :referral, presence: true
      validates :contact_details_complete, inclusion: { in: [true, false] }

      def contact_details_complete=(value)
        @contact_details_complete = ActiveModel::Type::Boolean.new.cast(value)
      end

      def save
        return false unless valid?

        referral.update(contact_details_complete:)
      end
    end
  end
end
