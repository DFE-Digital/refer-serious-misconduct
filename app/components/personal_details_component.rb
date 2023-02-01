class PersonalDetailsComponent < ViewComponent::Base
  include ActiveModel::Model
  include ReferralHelper

  attr_accessor :referral

  def rows
    rows = [name_row, any_other_name_row]

    rows.push(other_name_row) if referral.name_has_changed?

    return rows if referral.from_member_of_public?

    rows.push(date_of_birth_known_row)
    rows.push(date_of_birth_row) if referral.age_known?
    rows.push(ni_number_known_row)
    rows.push(ni_number_row) if referral.ni_number_known?
    rows.push(trn_known_row)
    rows.push(trn_row) if referral.trn_known?
    rows.push(qts_row)

    rows
  end

  def any_other_name_row
    {
      actions: [
        {
          text: "Change",
          href:
            polymorphic_path(
              [:edit, referral.routing_scope, referral, :personal_details_name],
              return_to: request.path
            ),
          visually_hidden_text: "if you know them by any other name"
        }
      ],
      key: {
        text: "Do you know them by any other name?"
      },
      value: {
        text: referral.name_has_changed&.humanize
      }
    }
  end

  def name_row
    {
      actions: [
        {
          text: "Change",
          href:
            polymorphic_path(
              [:edit, referral.routing_scope, referral, :personal_details_name],
              return_to: request.path
            ),
          visually_hidden_text: "their name"
        }
      ],
      key: {
        text: "Their name"
      },
      value: {
        text: "#{referral.first_name} #{referral.last_name}"
      }
    }
  end

  def other_name_row
    {
      actions: [
        {
          text: "Change",
          href:
            polymorphic_path(
              [:edit, referral.routing_scope, referral, :personal_details_name],
              return_to: request.path
            ),
          visually_hidden_text: "their other name"
        }
      ],
      key: {
        text: "Other name"
      },
      value: {
        text: referral.previous_name
      }
    }
  end

  def date_of_birth_row
    {
      actions: [
        {
          text: "Change",
          href:
            polymorphic_path(
              [:edit, referral.routing_scope, referral, :personal_details_age],
              return_to: request.path
            ),
          visually_hidden_text: "date of birth"
        }
      ],
      key: {
        text: "Date of birth"
      },
      value: {
        text: referral.date_of_birth&.to_fs(:long_ordinal_uk)
      }
    }
  end

  def date_of_birth_known_row
    {
      actions: [
        {
          text: "Change",
          href:
            polymorphic_path(
              [:edit, referral.routing_scope, referral, :personal_details_age],
              return_to: request.path
            ),
          visually_hidden_text: "if you know their date of birth"
        }
      ],
      key: {
        text: "Do you know their date of birth"
      },
      value: {
        text: referral.age_known? ? "Yes" : "No"
      }
    }
  end

  def trn_known_row
    {
      actions: [
        {
          text: "Change",
          href:
            polymorphic_path(
              [:edit, referral.routing_scope, referral, :personal_details_trn],
              return_to: request.path
            ),
          visually_hidden_text:
            "if you know their teacher reference number (TRN)"
        }
      ],
      key: {
        text: "Do you know their teacher reference number (TRN)?"
      },
      value: {
        text: referral.trn.present? ? "Yes" : "No"
      }
    }
  end

  def trn_row
    {
      actions: [
        {
          text: "Change",
          href:
            polymorphic_path(
              [:edit, referral.routing_scope, referral, :personal_details_trn],
              return_to: request.path
            ),
          visually_hidden_text: "teacher reference number (TRN)"
        }
      ],
      key: {
        text: "Teacher reference number (TRN)"
      },
      value: {
        text: referral.trn
      }
    }
  end

  def qts_row
    {
      actions: [
        {
          text: "Change",
          href:
            polymorphic_path(
              [:edit, referral.routing_scope, referral, :personal_details_qts],
              return_to: request.path
            ),
          visually_hidden_text: "if they have qualified teacher status (QTS)"
        }
      ],
      key: {
        text: "Do they have qualified teacher status (QTS)?"
      },
      value: {
        text: referral.has_qts&.humanize
      }
    }
  end

  def ni_number_known_row
    {
      actions: [
        {
          text: "Change",
          href:
            polymorphic_path(
              [
                :edit,
                referral.routing_scope,
                referral,
                :personal_details_ni_number
              ],
              return_to: request.path
            ),
          visually_hidden_text: "if you know their National Insurance number"
        }
      ],
      key: {
        text: "Do you know their National Insurance number?"
      },
      value: {
        text: referral.ni_number_known? ? "Yes" : "No"
      }
    }
  end

  def ni_number_row
    {
      actions: [
        {
          text: "Change",
          href:
            polymorphic_path(
              [
                :edit,
                referral.routing_scope,
                referral,
                :personal_details_ni_number
              ],
              return_to: request.path
            ),
          visually_hidden_text: "their National Insurance number"
        }
      ],
      key: {
        text: "National Insurance number"
      },
      value: {
        text: referral.ni_number
      }
    }
  end
end
