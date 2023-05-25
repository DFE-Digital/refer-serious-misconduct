# frozen_string_literal: true
module Referrals
  module AllegationDetails
    class CheckAnswersForm < FormItem
      validates :allegation_details_complete, inclusion: { in: [true, false] }
      validate :allegation_not_incomplete

      attr_referral :allegation_details_complete

      def save
        referral.update(allegation_details_complete:) if valid?
      end

      def allegation_not_incomplete
        errors.add(:base, :allegation_incomplete) if referral.allegation_format == "incomplete"
      end

      def section_class
        Referrals::Sections::AllegationDetailsSection
      end
    end
  end
end
