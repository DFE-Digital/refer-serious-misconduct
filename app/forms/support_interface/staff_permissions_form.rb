# frozen_string_literal: true
module SupportInterface
  class StaffPermissionsForm
    include ActiveModel::Model

    attr_accessor :staff, :view_support, :manage_referrals, :feedback_notification

    validate :permissions_are_valid

    def save
      return false if invalid?

      staff.update(view_support:, manage_referrals:, feedback_notification:)
    end

    private

    def permissions_are_valid
      return if manage_referrals || view_support

      errors.add(:permissions, I18n.t("validation_errors.missing_staff_permission"))
    end
  end
end
