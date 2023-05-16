module Referrals
  module TeacherRole
    class WorkLocationForm < FormItem
      attr_referral :work_organisation_name,
                    :work_address_line_1,
                    :work_address_line_2,
                    :work_town_or_city,
                    :work_postcode

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
        errors.add(:work_postcode, :invalid) unless UKPostcode.parse(work_postcode).full_valid?
      end
    end
  end
end
