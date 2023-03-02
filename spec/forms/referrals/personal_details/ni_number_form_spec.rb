# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::PersonalDetails::NiNumberForm, type: :model do
  context "when ni_number_known is true" do
    subject { described_class.new(ni_number_known: "true") }

    it { is_expected.to validate_presence_of(:ni_number) }
  end

  describe "#save" do
    subject(:save) { form.save }

    let(:form) { described_class.new(referral:, ni_number_known:, ni_number:) }
    let(:ni_number) { "AB123456C" }
    let(:ni_number_known) { "true" }
    let(:referral) { build(:referral) }

    it "updates the ni_number_known" do
      save
      expect(referral.ni_number_known).to be_truthy
    end

    it "updates the ni_number" do
      save
      expect(referral.ni_number).to eq(ni_number)
    end

    context "with an invalid NI number" do
      let(:ni_number) { "AB1234566" }

      before { save }

      it "does not update the ni_number" do
        expect(referral.ni_number).to be_nil
      end

      it "adds an error to the form" do
        expect(form.errors[:ni_number]).to eq(
          ["Enter a National Insurance number in the correct format"]
        )
      end
    end
  end
end
