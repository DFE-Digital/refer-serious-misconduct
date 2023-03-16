require "rails_helper"

RSpec.describe Referrals::PreviousMisconduct::ReportedForm, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:referral) }
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    let(:referral) { build(:referral) }
    let(:form) { described_class.new(referral:, previous_misconduct_reported:) }
    let(:previous_misconduct_reported) { "true" }

    it { is_expected.to be_truthy }

    context "when previous_misconduct_reported is blank" do
      let(:previous_misconduct_reported) { "" }

      it { is_expected.to be_falsy }
    end
  end

  describe "#save" do
    subject(:save) { form.save }

    let(:referral) { build(:referral) }
    let(:form) { described_class.new(referral:, previous_misconduct_reported: "true") }

    it "saves the Referral" do
      save
      expect(referral.previous_misconduct_reported).to be_truthy
    end
  end
end
