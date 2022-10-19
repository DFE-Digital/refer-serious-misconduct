# == Schema Information
#
# Table name: eligibility_checks
#
#  id                    :bigint           not null, primary key
#  reporting_as          :string           not null
#  serious_misconduct    :string
#  teaching_in_england   :string
#  unsupervised_teaching :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
class EligibilityCheck < ApplicationRecord
  validates :reporting_as, presence: true

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
