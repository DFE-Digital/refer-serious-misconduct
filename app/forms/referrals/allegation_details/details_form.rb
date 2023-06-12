# frozen_string_literal: true
module Referrals
  module AllegationDetails
    class DetailsForm < FormItem
      validates :allegation_format, inclusion: { in: %w[details upload] }
      validates :allegation_details, presence: true, if: -> { allegation_format == "details" }
      validates :allegation_upload_file,
                presence: true,
                if: -> {
                  (allegation_format == "upload" && !referral.allegation_upload_file&.attached?) &&
                    !referral.allegation_upload&.scan_result_suspect?
                }
      validates :allegation_upload_file,
                file_upload: true,
                if: -> {
                  allegation_format == "upload" && !referral.allegation_upload&.scan_result_suspect?
                }

      attr_referral :allegation_details, :allegation_format, :allegation_upload_file

      def save
        return false if invalid?

        attrs = { allegation_format: }

        case allegation_format
        when "details"
          referral.allegation_upload&.destroy
          attrs.merge!(allegation_details:)
        when "upload"
          if allegation_upload_file.present? &&
               valid_upload_classes.member?(allegation_upload_file.class)
            referral.allegation_upload&.destroy
            referral.uploads.create(section: "allegation", file: allegation_upload_file)
            attrs.merge!(allegation_details: nil)
          end
        end

        referral.reload.update(attrs)
      end
    end
  end
end
