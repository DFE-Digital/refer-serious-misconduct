# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::PersonalDetails::TrnForm, type: :model do
  it do
    is_expected.to validate_inclusion_of(:trn_known).in_array(%w[true false])
  end

  describe "#save" do
    subject(:save) { trn_form.save }

    let(:trn_form) { described_class.new(referral:, trn_known:, trn:) }
    let(:referral) { Referral.new }
    let(:trn_known) { "true" }
    let(:trn) { "RP99/12345" }

    it "passes validation" do
      is_expected.to be_truthy
    end

    it "updates the trn attribute on the referral" do
      expect { save }.to change(referral, :trn).from(nil).to("9912345")
    end

    context "when no option is selected" do
      let(:trn) { nil }
      let(:trn_known) { nil }

      it "fails validation" do
        is_expected.to be_falsy
      end

      it "adds an error" do
        save
        expect(trn_form.errors[:trn_known]).to eq(
          ["Tell us if you know their TRN number"]
        )
      end
    end

    context "when TRN is not known" do
      let(:trn_known) { "false" }
      it "passes validation" do
        is_expected.to be_truthy
      end
    end

    context "when TRN is known but empty input submitted" do
      let(:trn) { "" }
      it "fails validation" do
        is_expected.to be_falsy
      end
      it "adds an error" do
        save
        expect(trn_form.errors[:trn]).to include("Enter their TRN number")
      end
    end

    context "when a value too short for a TRN is submitted" do
      let(:trn) { "RP99/123" }
      it "fails validation" do
        is_expected.to be_falsy
      end
      it "adds an error" do
        save
        expect(trn_form.errors[:trn]).to eq(
          ["Their TRN number should contain 7 digits"]
        )
      end
    end

    context "when a value too long for a TRN is submitted" do
      let(:trn) { "RP99/123456" }
      it "fails validation" do
        is_expected.to be_falsy
      end
      it "adds an error" do
        save
        expect(trn_form.errors[:trn]).to eq(
          ["Their TRN number should contain 7 digits"]
        )
      end
    end

    context "when a TRN includes non numeric characters" do
      let(:trn) { "RP/99-123-67" }
      it "passes validation" do
        is_expected.to be_truthy
      end
      it "strips all non numeric characters from the TRN" do
        expect { save }.to change(referral, :trn).from(nil).to("9912367")
      end
    end
  end
end
