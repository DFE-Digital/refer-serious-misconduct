# frozen_string_literal: true
module Referrals
  module Evidence
    class StartForm
      include ReferralFormSection

      attr_reader :has_evidence

      validates :has_evidence, inclusion: { in: [true, false] }

      def has_evidence=(value)
        @has_evidence = ActiveModel::Type::Boolean.new.cast(value)
      end

      def save
        return false if invalid?

        referral
          .update(has_evidence:)
          .tap { |result| referral.evidences.destroy_all if result && !has_evidence }
      end
    end
  end
end
