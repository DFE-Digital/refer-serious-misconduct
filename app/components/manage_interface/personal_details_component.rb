module ManageInterface
  class PersonalDetailsComponent < ViewComponent::Base
    include ActiveModel::Model
    include AddressHelper

    attr_accessor :referral

    def rows
      rows = [
        { key: { text: "First name" }, value: { text: referral.first_name } },
        { key: { text: "Last name" }, value: { text: referral.last_name } }
      ]

      if referral.name_has_changed == "no"
        rows.push(
          {
            key: {
              text: "Do you know them by any other name?"
            },
            value: {
              text: referral.name_has_changed.humanize
            }
          }
        )
      elsif referral.previous_name.present?
        rows.push({ key: { text: "Other name" }, value: { text: referral.previous_name } })
      end

      return rows unless referral.from_employer?

      if !referral.age_known
        rows.push({ key: { text: "Do you know their date of birth?" }, value: { text: "No" } })
      else
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

      if !referral.email_known
        rows.push({ key: { text: "Do you know their email address?" }, value: { text: "No" } })
      else
        rows.push({ key: { text: "Email address" }, value: { text: referral.email_address } })
      end

      if !referral.phone_known
        rows.push({ key: { text: "Do you know their phone number?" }, value: { text: "No" } })
      else
        rows.push({ key: { text: "Phone number" }, value: { text: referral.phone_number } })
      end

      if !referral.address_known
        rows.push({ key: { text: "Do you know their address?" }, value: { text: "No" } })
      else
        rows.push({ key: { text: "Address" }, value: { text: address(referral) } })
      end

      if !referral.ni_number_known
        rows.push(
          { key: { text: "Do you know their National Insurance number?" }, value: { text: "No" } }
        )
      else
        rows.push(
          { key: { text: "National Insurance number" }, value: { text: referral.ni_number } }
        )
      end

      if referral.trn.blank?
        rows.push(
          {
            key: {
              text: "Do you know their teacher reference number (TRN)?"
            },
            value: {
              text: "No"
            }
          }
        )
      else
        rows.push(
          { key: { text: "Teacher reference number (TRN)?" }, value: { text: referral.trn } }
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
