# frozen_string_literal: true
module Referrals
  module Evidence
    class UploadForm
      include ActiveModel::Model

      MAX_FILES = FileUploadValidator::MAX_FILES

      validate :evidence_selected
      validates :evidence_uploads, file_upload: true

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

        if referral.evidences.size + evidences.size > MAX_FILES
          errors.add(:evidence_uploads, :file_count, max_files: MAX_FILES)
          return false
        end

        referral.evidences << evidences.sort_by(&:filename)
      end
    end
  end
end
