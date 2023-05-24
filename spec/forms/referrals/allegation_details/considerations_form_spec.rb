# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::Allegation::ConsiderationsForm, type: :model do
  let(:referral) { build(:referral) }

  describe "#save" do
    subject(:save) { form.save }

    let(:allegation_consideration_details) { nil }

    let(:form) { described_class.new(referral:, allegation_consideration_details:) }

    context "with no allegation consideration details" do
      before { save }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:allegation_consideration_details]).to eq(
          ["Enter details of how the complaint was considered"]
        )
      end
    end

    context "with allegation consideration details" do
      let(:allegation_consideration_details) { "Some details" }

      before { save }

      it { is_expected.to be_truthy }

      it "adds does not add an error" do
        expect(form.errors[:allegation_consideration_details]).to be_empty
      end
    end
  end
end
