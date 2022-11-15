# frozen_string_literal: true
module Referrals
  module Allegation
    class DetailsForm
      include ActiveModel::Model

      validates :allegation_format,
                inclusion: {
                  in: %w[details incomplete upload]
                }
      validates :allegation_details,
                presence: true,
                if: -> { allegation_format == "details" }
      validates :allegation_upload,
                presence: true,
                if: -> { allegation_format == "upload" }

      attr_accessor :referral
      attr_writer :allegation_details, :allegation_format, :allegation_upload

      def allegation_details
        @allegation_details ||= referral.allegation_details
      end

      def allegation_format
        @allegation_format ||= referral.allegation_format
      end

      def allegation_upload
        @allegation_upload ||= referral.allegation_upload
      end

      def save
        return false if invalid?

        attrs = { allegation_format: }
        attrs[:allegation_details] = allegation_details if allegation_format ==
          "details"
        attrs[:allegation_upload] = allegation_upload if allegation_format ==
          "upload"

        referral.update(attrs)
        true
      end
    end
  end
end
