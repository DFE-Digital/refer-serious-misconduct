# frozen_string_literal: true
module Referrals
  module PersonalDetails
    class AgeForm
      include ReferralFormSection

      attr_accessor :date_params, :referral
      attr_writer :date_of_birth

      validates :age_known, inclusion: { in: [true, false] }
      validates :date_of_birth,
                date: {
                  above_16: true,
                  not_future: true,
                  past_century: true
                },
                if: -> { age_known }

      def age_known
        return @age_known if defined?(@age_known)
        @age_known = referral&.age_known
      end

      def age_known=(value)
        @age_known = ActiveModel::Type::Boolean.new.cast(value)
      end

      def date_of_birth
        @date_of_birth || referral&.date_of_birth
      end

      def save
        return false if invalid?

        attrs = { age_known: }
        attrs.merge!(date_of_birth:) if age_known
        attrs.merge!(date_of_birth: nil) unless age_known

        referral.update(attrs)
      end

      def slug
        "personal_details_age"
      end
    end
  end
end
