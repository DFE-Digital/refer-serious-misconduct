# == Schema Information
#
# Table name: eligibility_checks
#
#  id           :bigint           not null, primary key
#  reporting_as :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class EligibilityCheck < ApplicationRecord
  validates :reporting_as, presence: true

  def reporting_as_employer?
    reporting_as&.to_sym == :employer
  end
end
