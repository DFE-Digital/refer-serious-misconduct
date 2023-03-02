# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::PersonalDetails::TrnForm, type: :model do
  let(:referral) { build(:referral) }

  describe "#save" do
    subject(:save) { trn_form.save }

    let(:trn_form) { described_class.new(referral:, trn_known:, trn:) }
    let(:trn_known) { "true" }
    let(:trn) { "9912345" }

    it { is_expected.to be_truthy }

    it "updates the trn attribute on the referral" do
      expect { save }.to change(referral, :trn).from(nil).to("9912345")
    end

    context "when no option is selected" do
      let(:trn) { nil }
      let(:trn_known) { nil }

      it { is_expected.to be_falsey }

      it "adds an error" do
        save
        expect(trn_form.errors[:trn_known]).to eq(
          ["Select yes if you know their TRN"]
        )
      end
    end

    context "when TRN is not known" do
      let(:trn_known) { "false" }

      it { is_expected.to be_truthy }
    end

    context "when previous TRN is present and TRN is not known" do
      let(:referral) { build(:referral, trn: "9912345") }
      let(:trn_known) { "false" }

      it "clears the TRN" do
        save
        expect(referral.trn).to be_nil
      end
    end

    context "when TRN is known but empty input submitted" do
      let(:trn) { "" }

      it { is_expected.to be_falsey }

      it "adds an error" do
        save
        expect(trn_form.errors[:trn]).to include("Enter TRN")
      end
    end

    context "when a value too short for a TRN is submitted" do
      let(:trn) { "123" }

      it { is_expected.to be_falsey }

      it "adds an error" do
        save
        expect(trn_form.errors[:trn]).to eq(["TRN must be 7 digits"])
      end
    end

    context "when a value too long for a TRN is submitted" do
      let(:trn) { "123456" }

      it { is_expected.to be_falsey }

      it "adds an error" do
        save
        expect(trn_form.errors[:trn]).to eq(["TRN must be 7 digits"])
      end
    end

    context "when a TRN includes non numeric characters" do
      let(:trn) { "991237A" }

      it { is_expected.to be_falsey }

      it "adds an error" do
        save
        expect(trn_form.errors[:trn]).to eq(
          ["Enter a TRN in the correct format"]
        )
      end
    end
  end
end
