class Feedback < ApplicationRecord
  SATISFACTION_RATINGS = %w[
    very_satisfied
    satisfied
    neither_satisfied_or_dissatisfied
    dissatisfied
    very_dissatisfied
  ].freeze

  validates :satisfaction_rating, inclusion: { in: SATISFACTION_RATINGS }
  validates_presence_of :improvement_suggestion
  validates :contact_permission_given, inclusion: { in: [true, false] }
  validates :email, presence: true, if: :contact_permission_given?
end
