# frozen_string_literal: true
module Referrals
  module PersonalDetails
    class AgeForm
      include ActiveModel::Model
      include ValidatedDate

      attr_accessor :referral
      attr_writer :date_of_birth

      attr_reader :age_known

      validates :age_known, inclusion: { in: [true, false] }

      def age_known=(value)
        @age_known = ActiveModel::Type::Boolean.new.cast(value)
      end

      def date_of_birth
        @date_of_birth ||= referral.date_of_birth
      end

      def save(params = {})
        return false if invalid?

        referral.update(age_known:)

        return true unless age_known

        unless validated_date(
                 date_params: params,
                 attribute: :date_of_birth,
                 date_of_birth: true
               )
          return false
        end

        referral.update(age_known:, date_of_birth:)
        true
      end
    end
  end
end
