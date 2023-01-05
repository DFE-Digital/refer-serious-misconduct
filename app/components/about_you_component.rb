class AboutYouComponent < ViewComponent::Base
  include ActiveModel::Model
  include ReferralHelper

  attr_accessor :referral, :user

  delegate :referrer, to: :referral

  def rows
    items = [
      {
        actions: [
          {
            text: "Change",
            href:
              subsection_path(
                action: :edit,
                referral:,
                return_to: request.url,
                subsection: :referrer_name
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
          text: "Your email address"
        },
        value: {
          text: user.email
        }
      }
    ]

    if referral.from_employer?
      items.push(
        {
          actions: [
            {
              text: "Change",
              href:
                subsection_path(
                  action: :edit,
                  referral:,
                  return_to: request.url,
                  subsection: :referrer_job_title
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
        }
      )
    end

    items.push(
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
    )

    items
  end
end
