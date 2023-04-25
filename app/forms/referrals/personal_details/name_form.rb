module Referrals
  module PersonalDetails
    class NameForm
      include ReferralFormSection

      attr_writer :first_name, :last_name, :name_has_changed, :previous_name

      validates :first_name, :last_name, presence: true
      validates :name_has_changed, inclusion: { in: %w[yes no] }
      validates :previous_name, presence: true, if: -> { name_has_changed == "yes" }

      def first_name
        @first_name || referral&.first_name
      end

      def last_name
        @last_name || referral&.last_name
      end

      def name_has_changed
        @name_has_changed || referral&.name_has_changed
      end

      def previous_name
        @previous_name || referral&.previous_name
      end

      def save
        return false if invalid?

        referral.update(first_name:, last_name:, name_has_changed:, previous_name:)
      end

      def slug
        "personal_details_name"
      end
    end
  end
end
