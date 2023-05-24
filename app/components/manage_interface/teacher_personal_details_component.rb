module ManageInterface
  class PersonalDetailsComponent < ViewComponent::Base
    include ActiveModel::Model
    include ReferralHelper
    include AddressHelper

    attr_accessor :referral

    def rows
      summary_rows [
                     first_name_row,
                     last_name_row,
                     previous_name_row,
                     date_of_birth_row,
                     email_address_row,
                     phone_number_row,
                     address_row,
                     ni_number_row,
                     trn_row,
                     has_qts_row
                   ].compact
    end

    def title
      "Personal details"
    end

    private

    def first_name_row
      { label: "First name", value: referral.first_name }
    end

    def last_name_row
      { label: "Last name", value: referral.last_name }
    end

    def previous_name_row
      if referral.name_has_changed == "no"
        { label: "Do you know them by any other name?", value: "No" }
      elsif referral.name_has_changed == "yes" && referral.previous_name.present?
        { label: "Other name", value: referral.previous_name }
      end
    end

    def date_of_birth_row
      return unless referral.from_employer?

      if referral.age_known
        { label: "Date of birth", value: referral.date_of_birth&.to_fs(:long_ordinal_uk) }
      else
        { label: "Do you know their date of birth?", value: "No" }
      end
    end

    def email_address_row
      return unless referral.from_employer?

      if referral.email_known
        { label: "Email address", value: referral.email_address }
      else
        { label: "Do you know their email address?", value: "No" }
      end
    end

    def phone_number_row
      return unless referral.from_employer?

      if referral.phone_known
        { label: "Phone number", value: referral.phone_number }
      else
        { label: "Do you know their phone number?", value: "No" }
      end
    end

    def address_row
      return unless referral.from_employer?

      if referral.address_known
        { label: "Address", value: address(referral) }
      else
        { label: "Do you know their address?", value: "No" }
      end
    end

    def ni_number_row
      return unless referral.from_employer?

      if referral.ni_number_known
        { label: "National Insurance number", value: referral.ni_number }
      else
        { label: "Do you know their National Insurance number?", value: "No" }
      end
    end

    def trn_row
      return unless referral.from_employer?

      if referral.trn.blank?
        { label: "Do you know their teacher reference number (TRN)?", value: "No" }
      else
        { label: "Teacher reference number (TRN)?", value: referral.trn }
      end
    end

    def has_qts_row
      return unless referral.from_employer?

      { label: "Do they have qualified teacher status?", value: referral.has_qts&.humanize }
    end
  end
end
