module ManageInterface
  class PersonalDetailsComponent < ViewComponent::Base
    include ActiveModel::Model
    include AddressHelper

    attr_accessor :referral

    def rows
      items = []

      items.push(first_name_row)
      items.push(last_name_row)
      items.push(other_name_row)

      return items unless referral.from_employer?

      items.push(date_of_birth_row)
      items.push(email_address_row)
      items.push(phone_number_row)
      items.push(address_row)
      items.push(ni_number_row)
      items.push(trn_row)
      items.push(qts_row)

      items
    end

    def title
      "Personal details"
    end

    private

    def first_name_row
      { key: { text: "First name" }, value: { text: referral.first_name } }
    end

    def last_name_row
      { key: { text: "Last name" }, value: { text: referral.last_name } }
    end

    def other_name_row
      if referral.name_has_changed?
        { key: { text: "Other name" }, value: { text: referral.previous_name } }
      else
        negative_answer_for("Do you know them by any other name?")
      end
    end

    def date_of_birth_row
      if referral.age_known?
        {
          key: {
            text: "Date of birth"
          },
          value: {
            text: referral.date_of_birth&.to_fs(:long_ordinal_uk)
          }
        }
      else
        negative_answer_for("Do you know their date of birth?")
      end
    end

    def email_address_row
      if referral.email_known?
        {
          key: {
            text: "Email address"
          },
          value: {
            text: referral.email_address
          }
        }
      else
        {
          key: {
            text: "Do you know their email address?"
          },
          value: {
            text: "No"
          }
        }
      end
    end

    def phone_number_row
      if referral.phone_known?
        {
          key: {
            text: "Phone number"
          },
          value: {
            text: referral.phone_number
          }
        }
      else
        {
          key: {
            text: "Do you know their phone number?"
          },
          value: {
            text: "No"
          }
        }
      end
    end

    def address_row
      if referral.address_known?
        { key: { text: "Address" }, value: { text: address(referral) } }
      else
        { key: { text: "Do you know their address?" }, value: { text: "No" } }
      end
    end

    def ni_number_row
      if referral.ni_number_known?
        {
          key: {
            text: "National Insurance number"
          },
          value: {
            text: referral.ni_number
          }
        }
      else
        {
          key: {
            text: "Do you know their National Insurance number?"
          },
          value: {
            text: "No"
          }
        }
      end
    end

    def trn_row
      if referral.trn_known?
        {
          key: {
            text: "Teacher reference number (TRN)?"
          },
          value: {
            text: referral.trn
          }
        }
      else
        {
          key: {
            text: "Do you know their teacher reference number (TRN)?"
          },
          value: {
            text: "No"
          }
        }
      end
    end

    def qts_row
      {
        key: {
          text: "Do they have qualified teacher status?"
        },
        value: {
          text: referral.has_qts&.humanize
        }
      }
    end

    def negative_answer_for(question)
      { key: { text: question }, value: { text: "No" } }
    end
  end
end
