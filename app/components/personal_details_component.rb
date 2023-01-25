class PersonalDetailsComponent < ViewComponent::Base
  include ActiveModel::Model
  include ReferralHelper

  attr_accessor :referral

  def rows
    return [name_row] if referral.from_member_of_public?

    [
      name_row,
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
                  :personal_details_age
                ],
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
      },
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
                  :personal_details_trn
                ],
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
      },
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
                  :personal_details_qts
                ],
                return_to: request.path
              ),
            visually_hidden_text: "if they have QTS?"
          }
        ],
        key: {
          text: "Do they have QTS?"
        },
        value: {
          text: referral.has_qts&.humanize
        }
      }
    ]
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
          visually_hidden_text: "name"
        }
      ],
      key: {
        text: "Name"
      },
      value: {
        text: "#{referral.first_name} #{referral.last_name}"
      }
    }
  end
end
