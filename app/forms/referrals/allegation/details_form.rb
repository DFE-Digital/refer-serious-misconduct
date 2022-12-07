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
                file_upload: true,
                if: -> { allegation_format == "upload" }

      attr_accessor :referral,
                    :allegation_details,
                    :allegation_format,
                    :allegation_upload

      def save
        return false if invalid?

        attrs = { allegation_format: }
        case allegation_format
        when "details"
          referral.allegation_upload.purge
          attrs.merge!(allegation_details:)
        when "upload"
          attrs.merge!(allegation_details: nil, allegation_upload:)
        end

        referral.update(attrs)
      end
    end
  end
end
