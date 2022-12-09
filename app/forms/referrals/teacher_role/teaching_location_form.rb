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
      attr_reader :teaching_location_known

      validates :referral, presence: true
      validates :teaching_location_known, inclusion: { in: [true, false] }
      validates :teaching_organisation_name,
                :teaching_address_line_1,
                :teaching_town_or_city,
                :teaching_postcode,
                presence: true,
                if: -> { teaching_location_known }
      validate :postcode_is_valid,
               if: -> { teaching_postcode.present? && teaching_location_known }

      def teaching_location_known=(value)
        @teaching_location_known = ActiveModel::Type::Boolean.new.cast(value)
      end

      def save
        return false unless valid?

        address_attrs = {
          teaching_location_known:,
          teaching_organisation_name: nil,
          teaching_address_line_1: nil,
          teaching_address_line_2: nil,
          teaching_town_or_city: nil,
          teaching_postcode: nil
        }

        if teaching_location_known
          address_attrs.merge!(
            teaching_organisation_name:,
            teaching_address_line_1:,
            teaching_address_line_2:,
            teaching_town_or_city:,
            teaching_postcode:
          )
        end
        referral.update(address_attrs)
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
