module ManageInterface
  class PersonalDetailsComponent < ViewComponent::Base
    include ActiveModel::Model

    attr_accessor :referral

    def rows
      rows = [
        { key: { text: "First name" }, value: { text: referral.first_name } },
        { key: { text: "Last name" }, value: { text: referral.last_name } }
      ]

      rows.push(
        {
          key: {
            text: "Are they known by other name?"
          },
          value: {
            text: referral.name_has_changed
          }
        }
      )

      if referral.previous_name.present?
        rows.push(
          {
            key: {
              text: "Other name"
            },
            value: {
              text: referral.previous_name
            }
          }
        )
      end

      return rows unless referral.from_employer?

      rows.push(
        {
          key: {
            text: "Is their date of birth known?"
          },
          value: {
            text: referral.age_known ? "Yes" : "No"
          }
        }
      )

      if referral.date_of_birth.present?
        rows.push(
          {
            key: {
              text: "Date of birth"
            },
            value: {
              text: referral.date_of_birth&.to_fs(:long_ordinal_uk)
            }
          }
        )
      end

      rows.push(
        {
          key: {
            text: "Is their National Insurance number known?"
          },
          value: {
            text: referral.ni_number_known ? "Yes" : "No"
          }
        }
      )

      if referral.ni_number.present?
        rows.push(
          {
            key: {
              text: "National Insurance number"
            },
            value: {
              text: referral.ni_number
            }
          }
        )
      end

      rows.push(
        {
          key: {
            text: "Do they have qualified teacher status?"
          },
          value: {
            text: referral.has_qts&.humanize
          }
        }
      )
      rows
    end

    def title
      "Personal details"
    end
  end
end
