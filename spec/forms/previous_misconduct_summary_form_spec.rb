require "rails_helper"

RSpec.describe PreviousMisconductSummaryForm, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:referral) }
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    let(:form) { described_class.new(referral:, summary:) }
    let(:referral) { build(:referral) }
    let(:summary) { "Name" }

    it { is_expected.to be_truthy }

    context "when summary is blank" do
      let(:summary) { "" }

      it { is_expected.to be_falsy }
    end
  end

  describe "#save" do
    subject(:save) { form.save }

    let(:form) { described_class.new(referral:, summary:) }
    let(:referral) { build(:referral) }
    let(:summary) { "This is the summary" }

    it "saves the summary" do
      save
      expect(referral.previous_misconduct_summary).to eq("This is the summary")
    end
  end
end
