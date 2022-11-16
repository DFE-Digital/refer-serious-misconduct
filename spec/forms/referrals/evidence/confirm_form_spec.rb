# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::Evidence::ConfirmForm, type: :model do
  describe "#save" do
    let(:referral) { build(:referral) }
    let(:evidence_details_complete) { "false" }
    subject(:save) { confirm_form.save }

    let(:confirm_form) do
      described_class.new(referral:, evidence_details_complete:)
    end

    context "with a valid value" do
      it "saves the value on the referral" do
        save
        expect(referral.evidence_details_complete).to eq(false)
      end
    end

    context "with no values" do
      let(:evidence_details_complete) { nil }
      it "adds an error" do
        save
        expect(confirm_form.errors[:evidence_details_complete]).to eq(
          ["Tell us if you have completed this section"]
        )
      end
    end
  end
end
