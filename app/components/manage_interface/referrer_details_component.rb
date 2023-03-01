module ManageInterface
  class ReferrerDetailsComponent < ViewComponent::Base
    include ActiveModel::Model
    include AddressHelper

    attr_accessor :referral

    def rows
      rows = [
        { key: { text: "First name" }, value: { text: referrer.first_name } },
        { key: { text: "Last name" }, value: { text: referrer.last_name } }
      ]
      if referral.from_employer?
        rows.push(
          { key: { text: "Job title" }, value: { text: referrer.job_title } }
        )
      end
      rows.push({ key: { text: "Type" }, value: { text: referral_type } })
      rows.push({ key: { text: "Email address" }, value: { text: user.email } })
      rows.push(
        { key: { text: "Phone number" }, value: { text: referrer.phone } }
      )
      if referral.from_employer?
        rows.push(
          {
            key: {
              text: "Employer"
            },
            value: {
              text: organisation_address(referral.organisation)
            }
          }
        )
      end

      rows
    end

    def title
      "Referrer details"
    end

    def referral_type
      referral.from_employer? ? "Employer" : "Public"
    end

    delegate :referrer, :user, to: :referral
  end
end
