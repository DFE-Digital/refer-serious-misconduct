class PersonalDetailsComponent < ViewComponent::Base
  include ActiveModel::Model

  attr_accessor :referral

  def rows
    [
      {
        actions: [
          {
            text: "Change",
            href:
              edit_referral_personal_details_name_path(
                referral,
                return_to: request.url
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
      },
      {
        actions: [
          {
            text: "Change",
            href:
              edit_referral_personal_details_age_path(
                referral,
                return_to: request.url
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
              referrals_edit_personal_details_trn_path(
                referral,
                return_to: request.url
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
              referrals_edit_personal_details_qts_path(
                referral,
                return_to: request.url
              ),
            visually_hidden_text: "do they have QTS?"
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
end
