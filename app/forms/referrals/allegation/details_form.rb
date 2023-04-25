# frozen_string_literal: true
module Referrals
  module Allegation
    class DetailsForm
      include ReferralFormSection

      validates :allegation_format, inclusion: { in: %w[details upload] }
      validates :allegation_details, presence: true, if: -> { allegation_format == "details" }
      validates :allegation_upload,
                presence: true,
                if: -> { allegation_format == "upload" && !referral.allegation_upload.attached? }
      validates :allegation_upload, file_upload: true, if: -> { allegation_format == "upload" }

      attr_writer :allegation_details, :allegation_format, :allegation_upload

      def allegation_details
        @allegation_details ||= referral&.allegation_details
      end

      def allegation_format
        @allegation_format ||= referral&.allegation_format
      end

      def allegation_upload
        @allegation_upload ||= referral&.allegation_upload
      end

      def slug
        "allegation_details"
      end

      def save
        return false if invalid?

        attrs = { allegation_format: }

        case allegation_format
        when "details"
          referral.allegation_upload.purge
          attrs.merge!(allegation_details:)
        when "upload"
          if allegation_upload.present? && valid_upload_classes.member?(allegation_upload.class)
            attrs.merge!(allegation_details: nil, allegation_upload:)
          end
        end

        referral.update(attrs)
      end
    end
  end
end
