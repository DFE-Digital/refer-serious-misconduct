require "rails_helper"

RSpec.describe OrganisationForm, type: :model do
  it { is_expected.to validate_presence_of(:referral) }

  describe "#save" do
    subject(:save) { form.save }

    let(:complete) { "true" }
    let(:form) { described_class.new(complete:, referral:) }
    let(:organisation) { build(:organisation) }
    let(:referral) { organisation.referral }

    it { is_expected.to be_truthy }

    it "updates the organisation" do
      save
      expect(organisation).to be_completed
    end

    context "when the form is not valid" do
      let(:referral) { nil }

      it { is_expected.to be_falsey }
    end
  end

  describe "#complete" do
    subject(:form_complete) { form.complete }

    let(:form) { described_class.new(complete:, referral:) }
    let(:organisation) { build(:organisation) }
    let(:referral) { organisation.referral }

    context "when the value of complete is nil" do
      let(:complete) { nil }
      let(:organisation) { build(:organisation) }

      it "returns the value from the organisation" do
        expect(form_complete).to eq(organisation.completed?)
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
