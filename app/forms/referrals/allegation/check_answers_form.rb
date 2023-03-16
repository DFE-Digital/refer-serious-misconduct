# frozen_string_literal: true
module Referrals
  module Allegation
    class CheckAnswersForm
      include ReferralFormSection

      validates :allegation_details_complete, inclusion: { in: [true, false] }
      validate :allegation_not_incomplete

      attr_reader :allegation_details_complete

      def allegation_details_complete=(value)
        @allegation_details_complete = ActiveModel::Type::Boolean.new.cast(value)
      end

      def save
        referral.update(allegation_details_complete:) if valid?
      end

      def allegation_not_incomplete
        errors.add(:base, :allegation_incomplete) if referral.allegation_format == "incomplete"
      end
    end
  end
end
