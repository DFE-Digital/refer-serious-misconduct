class AboutYouComponent < ViewComponent::Base
  include ActiveModel::Model
  include ReferralHelper
  include ComponentHelper

  attr_accessor :referral, :user

  delegate :referrer, to: :referral

  def rows
    items = [
      {
        actions: [
          {
            text: "Change",
            href:
              polymorphic_path([:edit, referral.routing_scope, referral, :referrer_name], return_to: return_to_path),
            visually_hidden_text: "your name"
          }
        ],
        key: {
          text: "Your name"
        },
        value: {
          text: nullable_value_to_s("#{referrer&.first_name} #{referrer&.last_name}".presence)
        }
      },
      { actions: [], key: { text: "Your email address" }, value: { text: user.email } }
    ]

    if referral.from_employer?
      items.push(
        {
          actions: [
            {
              text: "Change",
              href:
                polymorphic_path(
                  [:edit, referral.routing_scope, referral, :referrer_job_title],
                  return_to: return_to_path
                ),
              visually_hidden_text: "your job title"
            }
          ],
          key: {
            text: "Your job title"
          },
          value: {
            text: nullable_value_to_s(referrer&.job_title)
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
              polymorphic_path([:edit, referral.routing_scope, referral, :referrer_phone], return_to: return_to_path),
            visually_hidden_text: "your phone number"
          }
        ],
        key: {
          text: "Your phone number"
        },
        value: {
          text: nullable_value_to_s(referrer&.phone)
        }
      }
    )

    referral.submitted? ? remove_actions(items) : items
  end
end
