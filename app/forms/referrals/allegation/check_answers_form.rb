# frozen_string_literal: true
module Referrals
  module Allegation
    class CheckAnswersForm
      include ActiveModel::Model

      validates :allegation_details_complete, inclusion: { in: [true, false] }
      validate :allegation_not_incomplete

      attr_accessor :referral
      attr_reader :allegation_details_complete

      def allegation_details_complete=(value)
        @allegation_details_complete =
          ActiveModel::Type::Boolean.new.cast(value)
      end

      def save
        referral.update(allegation_details_complete:) if valid?
      end

      def allegation_not_incomplete
        if referral.allegation_format == "incomplete"
          errors.add(:base, :allegation_incomplete)
        end
      end

      def allegation_details
        if referral.allegation_upload.attached?
          "File: #{referral.allegation_upload.filename}"
        elsif referral.allegation_details.present?
          referral.allegation_details.truncate(150, " ")
        else
          "Incomplete"
        end
      end
    end
  end
end
