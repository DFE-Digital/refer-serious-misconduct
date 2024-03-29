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

  describe "#serious_misconduct?" do
    subject { described_class.new(serious_misconduct:).serious_misconduct? }

    context "when the value is no" do
      let(:serious_misconduct) { "no" }

      it { is_expected.to be_falsey }
    end

    context "when the value is yes" do
      let(:serious_misconduct) { "yes" }

      it { is_expected.to be_truthy }
    end

    context "when the value is not_sure" do
      let(:serious_misconduct) { "not_sure" }

      it { is_expected.to be_truthy }
    end
  end

  describe "#continue_with_referral?" do
    subject { described_class.new(continue_with:).continue_with_referral? }

    context "when the value is referral" do
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

  describe "#clear_answers!" do
    let(:eligibility_check) { create(:eligibility_check, :complete) }

    before { eligibility_check.clear_answers! }

    it "clears the answers" do
      expect(eligibility_check.reporting_as).not_to be_nil
      expect(eligibility_check.is_teacher).to be_nil
      expect(eligibility_check.serious_misconduct).to be_nil
      expect(eligibility_check.teaching_in_england).to be_nil
    end
  end

  describe "#format_complained" do
    let(:formatted_complaint_field) do
 described_class.new(complained:, complaint_status:, reporting_as:).format_complained end

    context "when employer submitted has not complained" do
      let(:reporting_as) { :employer }
      let(:complained) { false }
      let(:complaint_status) { nil }

      it "correctly outputs the correct message" do
        expect(formatted_complaint_field).to eql("no")
      end
    end

    context "when employer submitted has complained" do
      let(:reporting_as) { :employer }
      let(:complained) { true }
      let(:complaint_status) { nil }

      it "correctly outputs the correct message" do
        expect(formatted_complaint_field).to eql("yes")
      end
    end

    context "when public submitted has not complained" do
      let(:reporting_as) { :public }
      let(:complained) { false }
      let(:complaint_status) { "no" }

      it "correctly outputs the correct message" do
        expect(formatted_complaint_field).to eql("No complaint submitted")
      end
    end

    context "when public submitted has complained with response" do
      let(:reporting_as) { :public }
      let(:complained) { true }
      let(:complaint_status) { "received" }

      it "correctly outputs the correct message" do
        expect(formatted_complaint_field).to eql("Yes, complaint submitted")
      end
    end

    context "when public submitted has complained, awaiting response" do
      let(:reporting_as) { :public }
      let(:complained) { true }
      let(:complaint_status) { "awaiting" }

      it "correctly outputs the correct message" do

        expect(formatted_complaint_field).to eql("Yes, awaiting response")
      end
    end
  end
end
