require "rails_helper"

RSpec.describe EligibilityScreener::RecentlyComplainedForm, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:eligibility_check) }
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    let(:eligibility_check) { EligibilityCheck.new }
    let(:form) { described_class.new(eligibility_check:, recently_complained:) }
    let(:recently_complained) { "true" }

    it { is_expected.to be_truthy }

    context "when recently_complained is blank" do
      let(:recently_complained) { "" }

      it { is_expected.to be_falsy }
    end
  end

  describe "#save" do
    subject(:save) { form.save }

    let(:eligibility_check) { EligibilityCheck.new }
    let(:form) { described_class.new(eligibility_check:, recently_complained: true) }

    it "saves the eligibility check" do
      save
      expect(eligibility_check.recently_complained).to be_truthy
    end
  end
end
