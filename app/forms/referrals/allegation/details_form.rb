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

      attr_accessor :allegation_details, :allegation_format, :allegation_upload

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
          attrs.merge!(allegation_details: nil, allegation_upload:) if allegation_upload.present?
        end

        referral.update(attrs)
      end
    end
  end
end
