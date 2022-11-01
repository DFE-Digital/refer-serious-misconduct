# == Schema Information
#
# Table name: eligibility_checks
#
#  id                    :bigint           not null, primary key
#  complained            :boolean
#  is_teacher            :string
#  reporting_as          :string           not null
#  serious_misconduct    :string
#  teaching_in_england   :string
#  unsupervised_teaching :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
class EligibilityCheck < ApplicationRecord
  validates :reporting_as, presence: true

  scope :complete, -> { where(serious_misconduct: "yes") }
  scope :group_by_day, -> { group("date_trunc('day', created_at)") }
  scope :incomplete,
        -> {
          where(is_teacher: nil)
            .or(where.not(teaching_in_england: "no"))
            .or(where.not(unsupervised_teaching: "no"))
            .or(where.not(serious_misconduct: "no"))
        }
  scope :ineligible,
        -> {
          where(unsupervised_teaching: "no").or(
            where(serious_misconduct: "no")
          ).or(where(teaching_in_england: "no"))
        }
  scope :previous_7_days,
        -> { where(created_at: 1.week.ago.beginning_of_day..) }

  def is_teacher?
    %w[yes].include?(is_teacher)
  end

  def reporting_as_employer?
    reporting_as&.to_sym == :employer
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
end
