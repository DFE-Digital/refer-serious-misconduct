module Referrals
  module TeacherRole
    class WorkLocationForm
      include ActiveModel::Model

      attr_accessor :referral,
                    :work_organisation_name,
                    :work_address_line_1,
                    :work_address_line_2,
                    :work_town_or_city,
                    :work_postcode

      validates :referral, presence: true
      validates :work_organisation_name,
                :work_address_line_1,
                :work_town_or_city,
                :work_postcode,
                presence: true
      validate :postcode_is_valid, if: -> { work_postcode.present? }

      def save
        return false unless valid?

        referral.update(
          work_organisation_name:,
          work_address_line_1:,
          work_address_line_2:,
          work_town_or_city:,
          work_postcode:
        )
      end

      private

      def postcode_is_valid
        unless UKPostcode.parse(work_postcode).full_valid?
          errors.add(:work_postcode, :invalid)
        end
      end
    end
  end
end
