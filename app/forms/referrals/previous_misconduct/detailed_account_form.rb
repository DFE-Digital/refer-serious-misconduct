module Referrals
  module PreviousMisconduct
    class DetailedAccountForm
      include ReferralFormSection

      attr_writer :previous_misconduct_format,
                  :previous_misconduct_details,
                  :previous_misconduct_upload

      validates :previous_misconduct_format, inclusion: { in: %w[details upload] }
      validates :previous_misconduct_details,
                presence: true,
                if: -> { previous_misconduct_format == "details" }
      validates :previous_misconduct_upload,
                presence: true,
                if: -> {
                  previous_misconduct_format == "upload" &&
                    !referral.previous_misconduct_upload.attached?
                }
      validates :previous_misconduct_upload,
                file_upload: true,
                if: -> { previous_misconduct_format == "upload" }

      def previous_misconduct_format
        @previous_misconduct_format ||= referral&.previous_misconduct_format
      end

      def previous_misconduct_details
        @previous_misconduct_details ||= referral&.previous_misconduct_details
      end

      def previous_misconduct_upload
        @previous_misconduct_upload ||= referral&.previous_misconduct_upload
      end

      def save
        return false unless valid?

        attrs = { previous_misconduct_format: }
        case previous_misconduct_format
        when "details"
          attrs.merge!(previous_misconduct_details:)
        when "upload"
          if previous_misconduct_upload.present? &&
               valid_upload_classes.member?(previous_misconduct_upload.class)
            attrs.merge!(previous_misconduct_details: nil, previous_misconduct_upload:)
          end
        end

        if previous_misconduct_upload.present? && previous_misconduct_format != "upload"
          referral.previous_misconduct_upload.purge
        end

        referral.update(attrs)
      end

      def slug
        "previous_misconduct_detailed_account"
      end
    end
  end
end
