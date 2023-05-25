# frozen_string_literal: true
module Referrals
  module AllegationDetails
    class DetailsForm < FormItem
      validates :allegation_format, inclusion: { in: %w[details upload] }
      validates :allegation_details, presence: true, if: -> { allegation_format == "details" }
      validates :allegation_upload,
                presence: true,
                if: -> { allegation_format == "upload" && !referral.allegation_upload.attached? }
      validates :allegation_upload, file_upload: true, if: -> { allegation_format == "upload" }

      attr_referral :allegation_details, :allegation_format, :allegation_upload

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
