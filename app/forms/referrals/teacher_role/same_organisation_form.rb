# frozen_string_literal: true
module Referrals
  module TeacherRole
    class SameOrganisationForm
      include ActiveModel::Model

      attr_accessor :referral
      attr_reader :same_organisation

      validates :referral, presence: true
      validates :same_organisation, inclusion: { in: [true, false] }

      def same_organisation=(value)
        @same_organisation = ActiveModel::Type::Boolean.new.cast(value)
      end

      def save
        return false if invalid?

        referral.update(same_organisation:)
      end
    end
  end
end
