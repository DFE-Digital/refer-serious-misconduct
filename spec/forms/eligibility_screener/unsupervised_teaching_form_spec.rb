require "rails_helper"

RSpec.describe EligibilityScreener::UnsupervisedTeachingForm, type: :model do
  describe "validations" do
    subject(:form) { described_class.new }

    it { is_expected.to validate_presence_of(:eligibility_check) }

    specify do
      expect(form).to validate_inclusion_of(:unsupervised_teaching).in_array(%w[yes no not_sure])
    end
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    let(:eligibility_check) { EligibilityCheck.new }
    let(:form) { described_class.new(eligibility_check:, unsupervised_teaching:) }
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
    let(:form) { described_class.new(eligibility_check:, unsupervised_teaching: "yes") }

    it "saves the eligibility check" do
      save
      expect(eligibility_check.unsupervised_teaching).to be_truthy
    end
  end
end