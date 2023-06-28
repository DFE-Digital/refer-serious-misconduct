class EligibilityCheck < ApplicationRecord
  has_one :referral

  validates :reporting_as, presence: true

  enum reporting_as: { employer: "employer", public: "public" }, _prefix: true
  enum continue_with: { complaint: "complaint", referral: "referral" }, _prefix: true

  scope :complete, -> { where(serious_misconduct: "yes").or(continue_with_referral) }
  scope :group_by_day, -> { group("date_trunc('day', created_at)") }
  scope :previous_7_days, -> { where(created_at: 1.week.ago.beginning_of_day..) }

  def is_teacher?
    %w[yes].include?(is_teacher)
  end

  def serious_misconduct?
    %w[yes not_sure].include?(serious_misconduct)
  end

  def teaching_in_england?
    %w[yes not_sure].include?(teaching_in_england)
  end

  def unsupervised_teaching?
    %w[yes not_sure].include?(unsupervised_teaching)
  end

  def clear_answers!
    unless reporting_as.nil?
      update!(
        is_teacher: nil,
        serious_misconduct: nil,
        teaching_in_england: nil,
        unsupervised_teaching: nil,
        continue_with: nil
      )
    end
  end
end
