require "rails_helper"

RSpec.describe EligibilityScreener::SeriousMisconductForm, type: :model do
  describe "validations" do
    subject(:form) { described_class.new }

    it { is_expected.to validate_presence_of(:eligibility_check) }

    specify do
      expect(form).to validate_inclusion_of(:serious_misconduct).in_array(%w[yes no not_sure])
    end
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    let(:eligibility_check) { EligibilityCheck.new }
    let(:form) { described_class.new(eligibility_check:, serious_misconduct:) }
    let(:serious_misconduct) { "yes" }

    it { is_expected.to be_truthy }

    context "when serious_misconduct is blank" do
      let(:serious_misconduct) { "" }

      it { is_expected.to be_falsy }
    end
  end

  describe "#save" do
    subject(:save) { form.save }

    let(:eligibility_check) { EligibilityCheck.new }
    let(:form) { described_class.new(eligibility_check:, serious_misconduct: "yes") }

    it "saves the eligibility check" do
      save
      expect(eligibility_check.serious_misconduct).to be_truthy
    end
  end
end
