require "rails_helper"

RSpec.describe Referrals::AllegationPreviousMisconduct::CheckAnswersForm, type: :model do
  let(:referral) { create(:referral) }
  let(:form) { described_class.new(referral:, previous_misconduct_complete:) }
  let(:previous_misconduct_complete) { true }

  describe "validations" do
    it { is_expected.to validate_presence_of(:referral) }
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    before { valid }

    it { is_expected.to be_truthy }

    context "when previous_misconduct_complete is blank" do
      let(:previous_misconduct_complete) { "" }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:previous_misconduct_complete]).to eq(
          ["Select yes if you’ve completed this section"]
        )
      end
    end
  end

  describe "#save" do
    before { form.save }

    it "saves previous_misconduct_complete" do
      expect(referral.previous_misconduct_complete).to be_truthy
    end

    context "when the form is marked as in progress" do
      let(:previous_misconduct_complete) { false }

      it "saves previous_misconduct_complete as false" do
        expect(referral.previous_misconduct_complete).to be_falsy
      end
    end
  end
end
