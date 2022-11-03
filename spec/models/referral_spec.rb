require 'rails_helper'

RSpec.describe Referral, type: :model do
  it { is_expected.to have_one(:referrer).dependent(:destroy) }
end
