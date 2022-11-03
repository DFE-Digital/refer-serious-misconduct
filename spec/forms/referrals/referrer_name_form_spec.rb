require "rails_helper"

RSpec.describe Referrals::ReferrerNameForm, type: :model do
  context "when the referral has no referrer" do
    subject { described_class.new(referral:) }

    let(:referral) { build(:referral) }

    it { is_expected.to validate_presence_of(:name) }
  end

  it { is_expected.to validate_presence_of(:referral) }

  describe "#save" do
    subject { form.save }

    let(:form) { described_class.new(name:, referral:) }

    context "when the form is invalid" do
      let(:name) { "" }
      let(:referral) { nil }

      it { is_expected.to be_falsey }
    end

    context "when the form is valid" do
      let(:name) { "Test" }
      let(:referral) { build(:referral) }

      it { is_expected.to be_truthy }
    end
  end

  describe "#name" do
    subject { form.name }

    let(:form) { described_class.new(referral:) }

    context "when the referrer is present" do
      let(:referral) { build(:referral) }

      before { build(:referrer, referral:) }

      it { is_expected.to eq(referral.referrer.name) }
    end

    context "when the referrer is not present" do
      let(:referral) { build(:referral) }

      it { is_expected.to be_nil }
    end
  end
end
