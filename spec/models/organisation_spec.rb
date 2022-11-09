# == Schema Information
#
# Table name: organisations
#
#  id           :bigint           not null, primary key
#  completed_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  referral_id  :bigint           not null
#
# Indexes
#
#  index_organisations_on_referral_id  (referral_id)
#
# Foreign Keys
#
#  fk_rails_...  (referral_id => referrals.id)
#
require "rails_helper"

RSpec.describe Organisation, type: :model do
  it { is_expected.to belong_to(:referral) }

  describe "#completed?" do
    context "when completed_at is not nil" do
      subject { build(:organisation, completed_at: Time.current) }

      it { is_expected.to be_completed }
    end

    context "when completed_at is nil" do
      subject { build(:organisation, completed_at: nil) }

      it { is_expected.not_to be_completed }
    end
  end

  describe "#status" do
    subject { organisation.status }

    context "when completed_at is not nil" do
      let(:organisation) { build(:organisation, completed_at: Time.current) }

      it { is_expected.to eq(:complete) }
    end

    context "when completed_at is nil" do
      let(:organisation) { build(:organisation, completed_at: nil) }

      it { is_expected.to eq(:incomplete) }
    end
  end
end
