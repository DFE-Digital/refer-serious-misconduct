# frozen_string_literal: true
module Referrals
  module Evidence
    class UploadForm
      include ActiveModel::Model

      validate :evidence_selected

      attr_accessor :referral, :evidence_uploads
      attr_reader :evidences

      def evidence_selected
        return if evidence_uploads&.any?(&:present?)

        errors.add(:evidence_uploads, :blank)
      end

      def save
        return false if invalid?

        @evidences =
          evidence_uploads.compact_blank.map do |upload|
            ::ReferralEvidence.new(
              filename: upload.original_filename,
              document: upload,
              referral:,
              categories: []
            )
          end

        referral.update(evidences: evidences.sort_by(&:filename))
      end
    end
  end
end
