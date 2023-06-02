module Referrals
  module AllegationPreviousMisconduct
    class DetailedAccountForm < FormItem
      attr_referral :previous_misconduct_format,
                    :previous_misconduct_details,
                    :previous_misconduct_upload_file

      validates :previous_misconduct_format, inclusion: { in: %w[details upload] }
      validates :previous_misconduct_details,
                presence: true,
                if: -> { previous_misconduct_format == "details" }
      validates :previous_misconduct_upload_file,
                presence: true,
                if: -> {
                  previous_misconduct_format == "upload" &&
                    !referral.previous_misconduct_upload_file
                }
      validates :previous_misconduct_upload_file,
                file_upload: true,
                if: -> { previous_misconduct_format == "upload" }

      def save
        return false unless valid?

        attrs = { previous_misconduct_format: }
        case previous_misconduct_format
        when "details"
          referral.previous_misconduct_upload&.destroy
          attrs.merge!(previous_misconduct_details:)
        when "upload"
          if previous_misconduct_upload_file.present? &&
               valid_upload_classes.member?(previous_misconduct_upload_file.class)
            referral.previous_misconduct_upload&.destroy
            referral.uploads.create(
              section: "previous_misconduct",
              file: previous_misconduct_upload_file
            )
            attrs.merge!(previous_misconduct_details: nil)
          end
        end

        referral.reload.update(attrs)
      end
    end
  end
end
