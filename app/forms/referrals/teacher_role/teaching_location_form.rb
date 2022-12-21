module Referrals
  module TeacherRole
    class TeachingLocationForm
      include ActiveModel::Model

      attr_accessor :referral,
                    :teaching_organisation_name,
                    :teaching_address_line_1,
                    :teaching_address_line_2,
                    :teaching_town_or_city,
                    :teaching_postcode

      validates :referral, presence: true
      validates :teaching_organisation_name,
                :teaching_address_line_1,
                :teaching_town_or_city,
                :teaching_postcode,
                presence: true
      validate :postcode_is_valid, if: -> { teaching_postcode.present? }

      def save
        return false unless valid?

        referral.update(
          teaching_organisation_name:,
          teaching_address_line_1:,
          teaching_address_line_2:,
          teaching_town_or_city:,
          teaching_postcode:
        )
      end

      private

      def postcode_is_valid
        unless UKPostcode.parse(teaching_postcode).full_valid?
          errors.add(:teaching_postcode, :invalid)
        end
      end
    end
  end
end
