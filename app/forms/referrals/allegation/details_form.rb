# frozen_string_literal: true
module Referrals
  module Allegation
    class DetailsForm < FormItem
      validates :allegation_format, inclusion: { in: %w[details upload] }
      validates :allegation_details, presence: true, if: -> { allegation_format == "details" }
      validates :allegation_attachment,
                presence: true,
                if: -> { allegation_format == "upload" && !referral.allegation_attachment }
      validates :allegation_attachment, file_upload: true, if: -> { allegation_format == "upload" }

      attr_referral :allegation_details, :allegation_format, :allegation_attachment

      def slug
        "allegation_details"
      end

      def save
        return false if invalid?

        attrs = { allegation_format: }

        case allegation_format
        when "details"
          referral.allegation_attachment&.destroy
          attrs.merge!(allegation_details:)
        when "upload"
          if allegation_attachment.present? &&
               valid_upload_classes.member?(allegation_attachment.class)
            referral.allegation_attachment&.destroy
            referral.uploads.create(section: "allegation", attachment: allegation_attachment)

            attrs.merge!(allegation_details: nil)
          end
        end

        referral.update(attrs)
      end
    end
  end
end
