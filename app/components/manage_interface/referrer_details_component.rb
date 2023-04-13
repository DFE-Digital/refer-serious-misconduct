module ManageInterface
  class ReferrerDetailsComponent < ViewComponent::Base
    include ActiveModel::Model
    include ReferralHelper
    include AddressHelper

    attr_accessor :referral

    def rows
      summary_rows [
                     first_name_row,
                     last_name_row,
                     job_title_row,
                     type_row,
                     email_row,
                     phone_row,
                     organisation_row
                   ].compact
    end

    def title
      "Referrer details"
    end

    def first_name_row
      { label: "First name", value: referrer.first_name }
    end

    def last_name_row
      { label: "Last name", value: referrer.last_name }
    end

    def job_title_row
      return unless referral.from_employer?

      { label: "Job title", value: referrer.job_title }
    end

    def type_row
      { label: "Type", value: referral_type }
    end

    def email_row
      { label: "Email address", value: user.email }
    end

    def phone_row
      { label: "Phone number", value: referrer.phone }
    end

    def organisation_row
      return unless referral.from_employer?

      { label: "Employer", value: organisation_address(referral.organisation) }
    end

    def referral_type
      referral.from_employer? ? "Employer" : "Public"
    end

    delegate :referrer, :user, to: :referral
  end
end
