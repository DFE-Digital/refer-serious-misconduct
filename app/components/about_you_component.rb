class AboutYouComponent < ViewComponent::Base
  include ActiveModel::Model

  attr_accessor :referral, :user

  delegate :referrer, to: :referral

  def rows
    [
      {
        actions: [
          {
            text: "Change",
            href:
              edit_referral_referrer_name_path(
                referral,
                return_to: request.url
              ),
            visually_hidden_text: "name"
          }
        ],
        key: {
          text: "Your name"
        },
        value: {
          text: referrer.name
        }
      },
      {
        actions: [],
        key: {
          text: "Email address"
        },
        value: {
          text: user.email
        }
      },
      {
        actions: [
          {
            text: "Change",
            href:
              edit_referral_referrer_job_title_path(
                referral,
                return_to: request.url
              ),
            visually_hidden_text: "job title"
          }
        ],
        key: {
          text: "Your job title"
        },
        value: {
          text: referrer.job_title
        }
      },
      {
        actions: [
          {
            text: "Change",
            href:
              edit_referral_referrer_phone_path(
                referral,
                return_to: request.url
              ),
            visually_hidden_text: "phone"
          }
        ],
        key: {
          text: "Your phone number"
        },
        value: {
          text: referrer.phone
        }
      }
    ]
  end
end
