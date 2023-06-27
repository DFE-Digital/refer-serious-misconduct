require "rails_helper"

RSpec.describe EligibilityScreener::SeriousMisconductForm, type: :model do
  describe "validations" do
    subject(:form) { described_class.new }

    it { is_expected.to validate_presence_of(:eligibility_check) }

    specify do
      expect(form).to validate_inclusion_of(:continue_with).in_array(%w[referral complaint])
    end
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    let(:eligibility_check) { EligibilityCheck.new }
    let(:form) { described_class.new(eligibility_check:, continue_with:) }
    let(:continue_with) { "complaint" }

    it { is_expected.to be_truthy }

    context "when continue_with is blank" do
      let(:continue_with) { "" }

      it { is_expected.to be_falsy }
    end
  end

  describe "#save" do
    subject(:save) { form.save }

    let(:eligibility_check) { EligibilityCheck.new }
    let(:form) { described_class.new(eligibility_check:, continue_with: "referral") }

    it "saves the eligibility check" do
      save
      expect(eligibility_check.continue_with).to eq("referral")
    end
  end
end
