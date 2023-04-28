# frozen_string_literal: true
module Referrals
  module TeacherRole
    class DutiesForm
      include ReferralFormSection

      attr_writer :duties_details, :duties_format, :duties_upload
      attr_referral :duties_details, :duties_format, :duties_upload

      validates :duties_format, inclusion: { in: %w[details upload] }
      validates :duties_details, presence: true, if: -> { duties_format == "details" }
      validates :duties_upload,
                presence: true,
                if: -> { duties_format == "upload" && !referral.duties_upload.attached? }
      validates :duties_upload, file_upload: true, if: -> { duties_format == "upload" }

      def save
        return false if invalid?

        attrs = { duties_format: }
        case duties_format
        when "details"
          attrs.merge!(duties_details:)
        when "upload"
          attrs.merge!(duties_details: nil, duties_upload:) if duties_upload.present?
        end

        referral.duties_upload.purge unless duties_upload.blank? && duties_format == "upload"
        referral.update(attrs)
      end

      def slug
        "teacher_role_duties"
      end
    end
  end
end
