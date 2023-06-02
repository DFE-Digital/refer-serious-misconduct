# frozen_string_literal: true
module Referrals
  module TeacherRole
    class DutiesForm < FormItem
      attr_referral :duties_details, :duties_format, :duties_upload_file

      validates :duties_format, inclusion: { in: %w[details upload] }
      validates :duties_details, presence: true, if: -> { duties_format == "details" }
      validates :duties_upload_file,
                presence: true,
                if: -> { duties_format == "upload" && !referral.duties_upload_file&.attached? }
      validates :duties_upload_file, file_upload: true, if: -> { duties_format == "upload" }

      def save
        return false if invalid?

        attrs = { duties_format: }
        case duties_format
        when "details"
          referral.duties_upload&.destroy
          attrs.merge!(duties_details:)
        when "upload"
          if duties_upload_file.present? && valid_upload_classes.member?(duties_upload_file.class)
            referral.duties_upload&.destroy
            referral.uploads.create(section: "duties", file: duties_upload_file)
            attrs.merge!(duties_details: nil)
          end
        end

        referral.reload.update(attrs)
      end
    end
  end
end
