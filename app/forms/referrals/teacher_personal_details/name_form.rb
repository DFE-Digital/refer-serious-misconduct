module Referrals
  module TeacherPersonalDetails
    class NameForm < FormItem
      attr_referral :first_name, :last_name, :name_has_changed, :previous_name

      validates :first_name, :last_name, presence: true
      validates :name_has_changed, inclusion: { in: %w[yes no] }
      validates :previous_name, presence: true, if: -> { name_has_changed == "yes" }

      def save
        return false if invalid?

        referral.update(first_name:, last_name:, name_has_changed:, previous_name:)
      end
    end
  end
end
