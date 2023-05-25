module Referrals
  class ReferrerDetailsComponent < ReferralFormBaseComponent
    def rows
      complete_rows.tap { |rows| rows.insert(complete_rows.any? ? 1 : 0, summary_row(**email_row)) }
    end

    def complete_rows
      section.complete_rows(all_rows - [summary_row(**email_row)])
    end

    def all_rows
      summary_rows [name_row, email_row, job_title_row, phone_row].compact
    end

    private

    def name_row
      { label: "Your name", value: referrer&.name, path: :name }
    end

    def email_row
      { label: "Your email address", value: user.email }
    end

    def job_title_row
      return unless referral.from_employer?

      { label: "Your job title", value: referrer&.job_title, path: :job_title }
    end

    def phone_row
      { label: "Your phone number", value: referrer&.phone, path: :phone }
    end

    def section
      Referrals::Sections::ReferrerDetailsSection.new(referral:)
    end
  end
end
