# frozen_string_literal: true
module Referrals
  module AllegationEvidence
    class UploadForm < FormItem
      MAX_FILES = FileUploadValidator::MAX_FILES

      validate :evidence_selected
      validates :evidence_uploads, file_upload: true

      attr_accessor :evidence_uploads

      def evidence_selected
        return if evidence_uploads&.any?(&:present?)

        errors.add(:evidence_uploads, :blank)
      end

      def save
        return false if invalid?

        if referral.evidence_uploads.size + evidence_uploads.compact_blank.size > MAX_FILES
          errors.add(:evidence_uploads, :file_count, max_files: MAX_FILES)
          return false
        end

        evidence_uploads.compact_blank.map do |upload|
          referral.uploads.create!(section: "evidence", file: upload)
        end
      end
    end
  end
end
