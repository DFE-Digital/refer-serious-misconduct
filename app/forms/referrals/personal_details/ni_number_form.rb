# frozen_string_literal: true
module Referrals
  module PersonalDetails
    class NiNumberForm
      include ActiveModel::Model

      attr_accessor :referral, :ni_number
      attr_reader :ni_number_known

      validates :ni_number, presence: true, if: -> { ni_number_known }
      validates :ni_number_known, inclusion: { in: [true, false] }

      def ni_number_known=(value)
        @ni_number_known = ActiveModel::Type::Boolean.new.cast(value)
      end

      def save
        return false unless valid?

        referral.update(
          ni_number_known:,
          ni_number: ni_number_known ? ni_number : nil
        )
      end
    end
  end
end
