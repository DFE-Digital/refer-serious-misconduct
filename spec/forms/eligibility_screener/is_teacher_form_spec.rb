require "rails_helper"

RSpec.describe EligibilityScreener::IsTeacherForm, type: :model do
  describe "validations" do
    subject(:form) { described_class.new }

    it { is_expected.to validate_presence_of(:eligibility_check) }

    specify { expect(form).to validate_inclusion_of(:is_teacher).in_array(%w[yes no]) }
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    let(:eligibility_check) { EligibilityCheck.new }
    let(:form) { described_class.new(eligibility_check:, is_teacher:) }
    let(:is_teacher) { "yes" }

    it { is_expected.to be_truthy }

    context "when is_teacher is blank" do
      let(:is_teacher) { "" }

      it { is_expected.to be_falsy }
    end
  end

  describe "#save" do
    subject(:save) { form.save }

    let(:eligibility_check) { EligibilityCheck.new }
    let(:form) { described_class.new(eligibility_check:, is_teacher: "yes") }

    it "saves the eligibility check" do
      save
      expect(eligibility_check.is_teacher).to be_truthy
    end
  end
end
