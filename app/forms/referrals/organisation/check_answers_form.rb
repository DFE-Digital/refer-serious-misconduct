module Referrals
  module Organisation
    class CheckAnswersForm
      include ReferralFormSection

      attr_reader :complete

      validates :complete, inclusion: { in: [true, false] }

      def complete=(value)
        @complete = ActiveModel::Type::Boolean.new.cast(value)
      end

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
