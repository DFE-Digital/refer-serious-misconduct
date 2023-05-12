module Referrals
  module Organisation
    class CheckAnswersForm
      include ReferralFormSection

      attr_organisation :complete

      validates :complete, inclusion: { in: [true, false] }

      def save
        return false unless valid?

        organisation.update(complete:)
      end

      private

      def organisation
        @organisation ||= referral&.organisation || referral&.build_organisation
      end
    end
  end
end
