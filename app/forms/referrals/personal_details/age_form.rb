# frozen_string_literal: true
module Referrals
  module PersonalDetails
    class AgeForm
      include ActiveModel::Model

      attr_accessor :date_params, :referral
      attr_reader :age_known
      attr_writer :date_of_birth

      validates :age_known, inclusion: { in: [true, false] }
      validates :date_of_birth,
                date: {
                  date_of_birth: true
                },
                if: -> { age_known }

      def age_known=(value)
        @age_known = ActiveModel::Type::Boolean.new.cast(value)
      end

      def date_of_birth
        @date_of_birth ||= referral&.date_of_birth
      end

      def save
        return false if invalid?

        attrs = { age_known: }
        attrs.merge!(date_of_birth:) if age_known

        referral.update(attrs)
      end
    end
  end
end
