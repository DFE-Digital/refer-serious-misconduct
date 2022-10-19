require "rails_helper"

RSpec.describe UnsupervisedTeachingForm, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:eligibility_check) }
    it do
      is_expected.to validate_inclusion_of(:unsupervised_teaching).in_array(
        %w[yes no not_sure]
      )
    end
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    let(:eligibility_check) { EligibilityCheck.new }
    let(:form) do
      described_class.new(eligibility_check:, unsupervised_teaching:)
    end
    let(:unsupervised_teaching) { "yes" }

    it { is_expected.to be_truthy }

    context "when unsupervised_teaching is blank" do
      let(:unsupervised_teaching) { "" }

      it { is_expected.to be_falsy }
    end
  end

  describe "#save" do
    subject(:save) { form.save }

    let(:eligibility_check) { EligibilityCheck.new }
    let(:form) do
      described_class.new(eligibility_check:, unsupervised_teaching: "yes")
    end

    it "saves the eligibility check" do
      save
      expect(eligibility_check.unsupervised_teaching).to be_truthy
    end
  end
end
