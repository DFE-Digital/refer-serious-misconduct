require "rails_helper"

RSpec.describe Referrals::ReferrerNameForm, type: :model do
  context "when the referral has no referrer" do
    subject { described_class.new(referral:) }

    let(:referral) { build(:referral) }

    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:last_name) }
  end

  it { is_expected.to validate_presence_of(:referral) }

  describe "#save" do
    subject { form.save }

    let(:form) { described_class.new(first_name:, last_name:, referral:) }

    context "when the form is invalid" do
      let(:first_name) { "" }
      let(:last_name) { "" }
      let(:referral) { nil }

      it { is_expected.to be_falsey }
    end

    context "when the form is valid" do
      let(:first_name) { "John" }
      let(:last_name) { "Doe" }
      let(:referral) { build(:referral) }

      it { is_expected.to be_truthy }
    end
  end

  describe "form attributes" do
    let(:first_name) { form.first_name }
    let(:last_name) { form.first_name }

    let(:form) { described_class.new(referral:) }

    context "when the referrer is present" do
      let(:referral) { build(:referral) }

      before { build(:referrer, referral:) }

      it "has the correct first_name value" do
        expect(first_name).to eq(referral.referrer.first_name)
      end

      it "has the correct last_name value" do
        expect(last_name).to eq(referral.referrer.last_name)
      end
    end

    context "when the referrer is not present" do
      let(:referral) { build(:referral) }

      it "has a nil first_name value" do
        expect(first_name).to be_nil
      end

      it "has a nil last_name value" do
        expect(last_name).to be_nil
      end
    end
  end
end
