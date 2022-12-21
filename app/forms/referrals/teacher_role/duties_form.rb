# frozen_string_literal: true
module Referrals
  module TeacherRole
    class DutiesForm
      include ActiveModel::Model

      attr_accessor :referral, :duties_details, :duties_format, :duties_upload

      validates :duties_format, inclusion: { in: %w[details upload] }
      validates :duties_details,
                presence: true,
                if: -> { duties_format == "details" }
      validates :duties_upload,
                presence: true,
                file_upload: true,
                if: -> {
                  duties_format == "upload" && !referral.duties_upload.attached?
                }

      def save
        return false if invalid?

        attrs = { duties_format: }
        case duties_format
        when "details"
          attrs.merge!(duties_details:)
        when "upload"
          if duties_upload.present?
            attrs.merge!(duties_details: nil, duties_upload:)
          end
        when "incomplete"
          attrs.merge!(duties_details: nil, duties_upload: nil)
        end

        unless duties_upload.blank? && duties_format == "upload"
          referral.duties_upload.purge
        end
        referral.update(attrs)
      end
    end
  end
end
