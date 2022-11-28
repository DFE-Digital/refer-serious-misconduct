# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::Evidence::StartForm, type: :model do
  describe "#save" do
    subject(:save) { start_form.save }

    let(:referral) { build(:referral) }
    let(:start_form) { described_class.new(referral:, has_evidence:) }
    let(:has_evidence) { "false" }

    context "with a valid value" do
      it "saves the value on the referral" do
        save
        expect(referral.has_evidence).to eq(false)
      end
    end

    context "with no values" do
      let(:has_evidence) { nil }

      it "adds an error" do
        save
        expect(start_form.errors[:has_evidence]).to eq(
          ["Tell us if you have evidence to upload"]
        )
      end
    end
  end
end
