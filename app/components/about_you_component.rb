class AboutYouComponent < ViewComponent::Base
  include ActiveModel::Model
  include ReferralHelper
  include ComponentHelper

  attr_accessor :referral, :user

  delegate :referrer, to: :referral

  def rows
    items = [your_name, your_email_address, your_job_title, your_phone_number].compact

    referral.submitted? ? remove_actions(items) : items
  end

  def your_name
    new_item(
      actions: [
        action(
          path: polymorphic_path([:edit, referral.routing_scope, referral, :referrer_name], return_to: return_to_path),
          options: {
            visually_hidden_text: "your name"
          }
        )
      ],
      label: "Your name",
      value: nullable_value_to_s("#{referrer&.first_name} #{referrer&.last_name}".presence)
    )
  end

  def your_email_address
    new_item(label: "Your email address", value: user.email)
  end

  def your_job_title
    return unless referral.from_employer?

    new_item(
      actions: [
        action(
          path:
            polymorphic_path([:edit, referral.routing_scope, referral, :referrer_job_title], return_to: return_to_path),
          options: {
            visually_hidden_text: "your job title"
          }
        )
      ],
      label: "Your job title",
      value: nullable_value_to_s(referrer&.job_title)
    )
  end

  def your_phone_number
    new_item(
      actions: [
        action(
          path: polymorphic_path([:edit, referral.routing_scope, referral, :referrer_phone], return_to: return_to_path),
          options: {
            visually_hidden_text: "your phone number"
          }
        )
      ],
      label: "Your phone number",
      value: nullable_value_to_s(referrer&.phone)
    )
  end
end
