# == Schema Information
#
# Table name: eligibility_checks
#
#  id           :bigint           not null, primary key
#  reporting_as :string           not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
require "rails_helper"

RSpec.describe EligibilityCheck, type: :model do
  it { is_expected.to validate_presence_of(:reporting_as) }
end
