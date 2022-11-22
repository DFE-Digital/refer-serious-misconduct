# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::Evidence::CategoriesForm, type: :model do
  describe "#save" do
    let(:referral) { create(:referral) }
    let(:evidence) { build(:referral_evidence, referral:) }
    let(:categories) { [""] }
    let(:categories_other) { nil }
    let(:categories_form) do
      described_class.new(referral:, evidence:, categories:, categories_other:)
    end

    subject(:save) { categories_form.save }

    context "with a valid value" do
      it "saves categories on the evidence record" do
        save
      end
    end

    context "when other category is selected" do
      context "without explanatory text" do
        let(:categories) { ["other"] }

        it "adds an error" do
          save
          expect(categories_form.errors[:categories_other]).to eq(
            ["Tell us what type of evidence this is"]
          )
        end
      end

      context "with explanatory text" do
        let(:categories) { %w[cv job_application other] }
        let(:categories_other) { "Something something else" }
        it "saves the category and text" do
          expect(save).to be true

          expect(evidence.categories).to eq(%w[cv job_application other])
          expect(evidence.categories_other).to eq("Something something else")
        end
      end
    end
  end

  describe "next_evidence" do
    let(:evidence) { build(:referral_evidence, referral:) }
    let(:evidences) { [evidence] }
    let(:referral) { create(:referral) }
    let(:categories_form) { described_class.new(referral:, evidence:) }

    before { referral.evidences = evidences }

    context "with no next evidence" do
      it "returns nil" do
        expect(categories_form.next_evidence).to be_nil
      end
    end

    context "with next evidence" do
      let(:next_evidence) { build(:referral_evidence, referral:) }
      let(:evidences) { [evidence, next_evidence] }

      it "returns next evidence" do
        expect(categories_form.next_evidence).to eq(next_evidence)
      end
    end
  end

  describe "previous_evidence" do
    let(:evidence) { build(:referral_evidence, referral:) }
    let(:evidences) { [evidence] }
    let(:referral) { create(:referral) }
    let(:categories_form) { described_class.new(referral:, evidence:) }

    before { referral.evidences = evidences }

    context "with no previous evidence" do
      it "returns nil" do
        expect(categories_form.previous_evidence).to be_nil
      end
    end

    context "with previous evidence" do
      let(:previous_evidence) { build(:referral_evidence, referral:) }
      let(:evidences) { [previous_evidence, evidence] }

      it "returns previous evidence" do
        expect(categories_form.previous_evidence).to eq(previous_evidence)
      end
    end
  end
end
