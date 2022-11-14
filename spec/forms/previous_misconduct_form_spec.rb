require "rails_helper"

RSpec.describe PreviousMisconductForm, type: :model do
  it { is_expected.to validate_presence_of(:referral) }

  describe "#save" do
    subject(:save) { form.save }

    let(:complete) { "true" }
    let(:form) { described_class.new(complete:, referral:) }
    let(:referral) { build(:referral) }

    it { is_expected.to be_truthy }

    it "updates the referral" do
      save
      expect(referral.previous_misconduct_completed_at).to be_present
    end

    context "when the form is not valid" do
      let(:referral) { nil }

      it { is_expected.to be_falsey }
    end
  end

  describe "#complete" do
    subject(:form_complete) { form.complete }

    let(:form) { described_class.new(complete:, referral:) }
    let(:referral) { build(:referral) }

    context "when the value of complete is nil" do
      let(:complete) { nil }
      let(:referral) do
        build(:referral, previous_misconduct_completed_at: Time.current)
      end

      it "returns the value from the referral" do
        expect(form_complete).to eq(true)
      end
    end

    context "when the value of complete is nil and there is no previous_misconduct on the referral" do
      let(:complete) { nil }
      let(:referral) { build(:referral, previous_misconduct_completed_at: nil) }

      it "returns nil" do
        expect(form_complete).to be_nil
      end
    end

    context "when the value of complete is set" do
      let(:complete) { true }

      it "returns the value of complete" do
        expect(complete).to eq(true)
      end
    end
  end
end
