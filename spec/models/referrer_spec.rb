require "rails_helper"

RSpec.describe Referrer, type: :model do
  it { is_expected.to belong_to(:referral) }

  describe "#status" do
    subject { referrer.status }

    let(:referrer) { build(:referrer) }

    it { is_expected.to eq(:incomplete) }

    context "when completed_at is present" do
      let(:referrer) { build(:referrer, complete: true) }

      it { is_expected.to eq(:completed) }
    end
  end

  describe "#completed?" do
    subject { referrer.completed? }

    let(:referrer) { build(:referrer) }

    context "when completed_at is nil" do
      it { is_expected.to be_falsey }
    end

    context "when completed_at is present" do
      let(:referrer) { build(:referrer, complete: true) }

      it { is_expected.to be_truthy }
    end
  end
end
