class ReminderEmail < ApplicationRecord
  belongs_to :referral

  scope :recent, -> { where(created_at: 8.days.ago..Time.zone.now) }
end
