require "rails_helper"

RSpec.describe EligibilityCheck, type: :model do
  it { is_expected.to validate_presence_of(:reporting_as) }

  describe "#reporting_as_employer?" do
    subject { described_class.new(reporting_as:).reporting_as_employer? }

    let(:reporting_as) { nil }

    it { is_expected.to be_falsey }

    context "when reporting_as is public" do
      let(:reporting_as) { "public" }

      it { is_expected.to be_falsey }
    end

    context "when reporting_as is employer" do
      let(:reporting_as) { "employer" }

      it { is_expected.to be_truthy }
    end
  end

  describe "#continue_with_referral?" do
    subject { described_class.new(continue_with:).continue_with_referral? }

    context "when the value is 'referral'" do
      let(:continue_with) { "referral" }

      it { is_expected.to be_truthy }
    end

    context "when the value is complaint" do
      let(:continue_with) { "complaint" }

      it { is_expected.to be_falsey }
    end
  end

  describe "#teaching_in_england?" do
    subject { described_class.new(teaching_in_england:).teaching_in_england? }

    context "when the value is no" do
      let(:teaching_in_england) { "no" }

      it { is_expected.to be_falsey }
    end

    context "when the value is yes" do
      let(:teaching_in_england) { "yes" }

      it { is_expected.to be_truthy }
    end

    context "when the value is not_sure" do
      let(:teaching_in_england) { "not_sure" }

      it { is_expected.to be_truthy }
    end
  end

  describe "#unsupervised_teaching" do
    subject { described_class.new(unsupervised_teaching:).unsupervised_teaching? }

    context "when the value is no" do
      let(:unsupervised_teaching) { "no" }

      it { is_expected.to be_falsey }
    end

    context "when the value is yes" do
      let(:unsupervised_teaching) { "yes" }

      it { is_expected.to be_truthy }
    end

    context "when the value is not_sure" do
      let(:unsupervised_teaching) { "not_sure" }

      it { is_expected.to be_truthy }
    end
  end

  describe "#clear_answers!" do
    let(:eligibility_check) { create(:eligibility_check, :complete, :not_unsupervised) }

    before { eligibility_check.clear_answers! }

    it "clears the answers" do
      expect(eligibility_check.reporting_as).not_to be_nil
      expect(eligibility_check.is_teacher).to be_nil
      expect(eligibility_check.serious_misconduct).to be_nil
      expect(eligibility_check.teaching_in_england).to be_nil
      expect(eligibility_check.unsupervised_teaching).to be_nil
    end
  end
end
