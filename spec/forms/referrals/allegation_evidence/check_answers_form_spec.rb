# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::AllegationEvidence::CheckAnswersForm, type: :model do
  describe "#save" do
    subject(:save) { check_answers_form.save }

    let(:referral) { build(:referral) }
    let(:check_answers_form) { described_class.new(referral:, evidence_details_complete:) }
    let(:evidence_details_complete) { "false" }

    context "with a valid value" do
      it "saves the value on the referral" do
        save
        expect(referral.evidence_details_complete).to be(false)
      end
    end

    context "with no values" do
      let(:evidence_details_complete) { nil }

      it "adds an error" do
        save
        expect(check_answers_form.errors[:evidence_details_complete]).to eq(
          ["Select yes if you’ve completed this section"]
        )
      end
    end
  end
end
