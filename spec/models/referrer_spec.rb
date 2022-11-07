# == Schema Information
#
# Table name: referrers
#
#  id          :bigint           not null, primary key
#  job_title   :string
#  name        :string
#  phone       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  referral_id :bigint           not null
#
# Indexes
#
#  index_referrers_on_referral_id  (referral_id)
#
# Foreign Keys
#
#  fk_rails_...  (referral_id => referrals.id)
#
require "rails_helper"

RSpec.describe Referrer, type: :model do
  it { is_expected.to belong_to(:referral) }

  describe "#status" do
    subject { referrer.status }

    let(:referrer) { build(:referrer) }

    it { is_expected.to eq(:incomplete) }
  end
end
