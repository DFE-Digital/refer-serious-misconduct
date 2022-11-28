require "rails_helper"

RSpec.describe TeachingInEnglandForm, type: :model do
  describe "validations" do
    subject(:form) { described_class.new }

    it { is_expected.to validate_presence_of(:eligibility_check) }

    specify do
      expect(form).to validate_inclusion_of(:teaching_in_england).in_array(
        %w[yes no not_sure]
      )
    end
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    let(:eligibility_check) { EligibilityCheck.new }
    let(:form) { described_class.new(eligibility_check:, teaching_in_england:) }
    let(:teaching_in_england) { "yes" }

    it { is_expected.to be_truthy }

    context "when teaching_in_england is blank" do
      let(:teaching_in_england) { "" }

      it { is_expected.to be_falsy }
    end
  end

  describe "#save" do
    subject(:save) { form.save }

    let(:eligibility_check) { EligibilityCheck.new }
    let(:form) do
      described_class.new(eligibility_check:, teaching_in_england: "yes")
    end

    it "saves the eligibility check" do
      save
      expect(eligibility_check.teaching_in_england).to be_truthy
    end
  end
end
