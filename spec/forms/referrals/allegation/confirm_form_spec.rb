# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::Allegation::ConfirmForm, type: :model do
  describe "#save" do
    subject(:save) { confirm_form.save }

    let(:referral) { build(:referral) }
    let(:confirm_form) do
      described_class.new(referral:, allegation_details_complete:)
    end
    let(:allegation_details_complete) { "false" }

    context "with a valid value" do
      it "saves the value on the referral" do
        save
        expect(referral.allegation_details_complete).to eq(false)
      end
    end

    context "with no values" do
      let(:allegation_details_complete) { nil }

      it "adds an error" do
        save
        expect(confirm_form.errors[:allegation_details_complete]).to eq(
          ["Tell us if you have completed this section"]
        )
      end
    end

    context "when the allegation details are not complete" do
      it "adds an error" do
        referral.allegation_format = "incomplete"
        save
        expect(confirm_form.errors[:base]).to eq(
          ["Please give details of the allegation"]
        )
      end
    end
  end
end
