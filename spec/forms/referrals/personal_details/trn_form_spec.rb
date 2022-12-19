# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::PersonalDetails::TrnForm, type: :model do
  let(:referral) { build(:referral) }

  describe "#save" do
    subject(:save) { trn_form.save }

    let(:trn_form) { described_class.new(referral:, trn_known:, trn:) }
    let(:trn_known) { "true" }
    let(:trn) { "RP99/12345" }

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

    context "when TRN is known but empty input submitted" do
      let(:trn) { "" }

      it { is_expected.to be_falsey }

      it "adds an error" do
        save
        expect(trn_form.errors[:trn]).to include("Enter their TRN")
      end
    end

    context "when a value too short for a TRN is submitted" do
      let(:trn) { "RP99/123" }

      it { is_expected.to be_falsey }

      it "adds an error" do
        save
        expect(trn_form.errors[:trn]).to eq(["TRN must be 7 digits"])
      end
    end

    context "when a value too long for a TRN is submitted" do
      let(:trn) { "RP99/123456" }

      it { is_expected.to be_falsey }

      it "adds an error" do
        save
        expect(trn_form.errors[:trn]).to eq(["TRN must be 7 digits"])
      end
    end

    context "when a TRN includes non numeric characters" do
      let(:trn) { "RP/99-123-67" }

      it { is_expected.to be_truthy }

      it "strips all non numeric characters from the TRN" do
        expect { save }.to change(referral, :trn).from(nil).to("9912367")
      end
    end
  end
end
