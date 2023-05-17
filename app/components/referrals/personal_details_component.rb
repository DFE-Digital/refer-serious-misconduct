module Referrals
  class PersonalDetailsComponent < ReferralFormBaseComponent
    def all_rows
      summary_rows(
        [
          [name_row, known_by_other_name_row, other_name_row],
          [date_of_birth_known_row, date_of_birth_row],
          [ni_number_known_row, ni_number_row],
          [trn_known_row, trn_row],
          [qts_row]
        ].map(&:compact).select(&:present?)
      )
    end

    private

    def known_by_other_name_row
      {
        label: "Do you know them by any other name?",
        value: referral.name_has_changed&.humanize,
        visually_hidden_text: "if you know them by any other name",
        path: :personal_details_name
      }
    end

    def name_row
      { label: "Their name", value: referral.name, path: :personal_details_name }
    end

    def other_name_row
      return unless referral.name_has_changed?

      { label: "Other name", value: referral.previous_name, path: :personal_details_name }
    end

    def date_of_birth_row
      return unless referral.from_employer?
      return unless referral.age_known?

      {
        label: "Date of birth",
        value: referral.date_of_birth&.to_fs(:long_ordinal_uk),
        path: :personal_details_age
      }
    end

    def date_of_birth_known_row
      return unless referral.from_employer?

      {
        label: "Do you know their date of birth?",
        value: referral.age_known,
        path: :personal_details_age,
        visually_hidden_text: "if you know their date of birth"
      }
    end

    def trn_known_row
      return unless referral.from_employer?

      {
        label: "Do you know their teacher reference number (TRN)?",
        value: referral.trn_known,
        path: :personal_details_trn,
        visually_hidden_text: "if you know their teacher reference number (TRN)"
      }
    end

    def trn_row
      return unless referral.from_employer?
      return unless referral.trn_known?

      {
        label: "TRN",
        value: referral.trn,
        path: :personal_details_trn,
        visually_hidden_text: "teacher reference number (TRN)"
      }
    end

    def qts_row
      return unless referral.from_employer?

      {
        label: "Do they have qualified teacher status (QTS)?",
        value: referral.has_qts&.humanize,
        path: :personal_details_qts,
        visually_hidden_text: "if they have qualified teacher status (QTS)"
      }
    end

    def ni_number_known_row
      return unless referral.from_employer?

      {
        label: "Do you know their National Insurance number?",
        value: referral.ni_number_known,
        path: :personal_details_ni_number,
        visually_hidden_text: "if you know their National Insurance number"
      }
    end

    def ni_number_row
      return unless referral.from_employer?
      return unless referral.ni_number_known?

      {
        label: "National Insurance number",
        value: referral.ni_number,
        path: :personal_details_ni_number,
        visually_hidden_text: "National Insurance number"
      }
    end

    def section
      Referrals::Sections::PersonalDetailsSection.new(referral:)
    end
  end
end
