module Referrals
  class AllegationPreviousMisconductComponent < ReferralFormBaseComponent
    def all_rows
      summary_rows(
        [
          [previous_misconduct_reported_row],
          [detailed_account_type_row, detailed_account_report_row]
        ].map(&:compact).select(&:present?)
      )
    end

    private

    def previous_misconduct_reported_row
      {
        label: "Has there been any previous misconduct?",
        visually_hidden_text: "if there has been any previous misconduct",
        value: humanize_three_way_choice(referral.previous_misconduct_reported),
        path: :reported
      }
    end

    def detailed_account_type_row
      return unless referral.previous_misconduct_reported?

      {
        label: "How do you want to give details about previous allegations?",
        visually_hidden_text: "how you want to give details about previous allegations",
        value: detail_type,
        path: :detailed_account
      }
    end

    def detailed_account_report_row
      return unless referral.previous_misconduct_reported?

      { label: "Detailed account", value: report, path: :detailed_account }
    end

    def report
      if referral.previous_misconduct_upload.attached?
        return(
          govuk_link_to(
            referral.previous_misconduct_upload.filename,
            rails_blob_path(referral.previous_misconduct_upload, disposition: "attachment")
          )
        )
      end

      if referral.previous_misconduct_details.present?
        return simple_format(referral.previous_misconduct_details)
      end

      "Not answered"
    end

    def detail_type
      case referral.previous_misconduct_format
      when "details"
        referral.previous_misconduct_details.present? ? "Describe the allegation" : "Incomplete"
      when "upload"
        referral.previous_misconduct_upload.attached? ? "Upload file" : "Incomplete"
      else
        "Not answered"
      end
    end

    def section
      Referrals::Sections::AllegationPreviousMisconductSection.new(referral:)
    end
  end
end
