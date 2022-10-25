require "rails_helper"

RSpec.describe HaveComplainedForm, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:eligibility_check) }
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    let(:eligibility_check) { EligibilityCheck.new }
    let(:form) { described_class.new(eligibility_check:, complained:) }
    let(:complained) { "true" }

    it { is_expected.to be_truthy }

    context "when complained is blank" do
      let(:complained) { "" }

      it { is_expected.to be_falsy }
    end
  end

  describe "#save" do
    subject(:save) { form.save }

    let(:eligibility_check) { EligibilityCheck.new }
    let(:form) { described_class.new(eligibility_check:, complained: true) }

    it "saves the eligibility check" do
      save
      expect(eligibility_check.complained).to be_truthy
    end
  end
end
