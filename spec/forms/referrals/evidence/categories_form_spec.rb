# frozen_string_literal: true
require "rails_helper"

RSpec.describe Referrals::Evidence::CategoriesForm, type: :model do
  describe "#save" do
    subject(:save) { categories_form.save }

    let(:referral) { create(:referral) }
    let(:evidence) { build(:referral_evidence, referral:) }
    let(:categories) { ["cv"] }
    let(:categories_other) { nil }
    let(:categories_form) do
      described_class.new(referral:, evidence:, categories:, categories_other:)
    end

    it { is_expected.to be_truthy }

    context "when other category is selected without explanatory text" do
      let(:categories) { ["other"] }

      it "adds an error" do
        save
        expect(categories_form.errors[:categories_other]).to eq(
          ["Tell us what type of evidence this is"]
        )
      end
    end

    context "when other category is selected with explanatory text" do
      let(:categories) { %w[cv job_application other] }
      let(:categories_other) { "Something something else" }

      it { is_expected.to be_truthy }

      it "saves the categories" do
        save
        expect(evidence.categories).to eq(%w[cv job_application other])
      end

      it "saves the explanatory text" do
        save
        expect(evidence.categories_other).to eq("Something something else")
      end
    end
  end

  describe "#next_evidence" do
    subject(:next_evidence) { categories_form.next_evidence }

    let(:evidence) { build(:referral_evidence, referral:) }
    let(:evidences) { [evidence] }
    let(:referral) { create(:referral) }
    let(:categories_form) { described_class.new(referral:, evidence:) }

    before { referral.evidences = evidences }

    it { is_expected.to be_nil }

    context "with a subsequent evidence record" do
      let(:more_evidence) { build(:referral_evidence, referral:) }
      let(:evidences) { [evidence, more_evidence] }

      it { is_expected.to eq(more_evidence) }
    end
  end

  describe "#previous_evidence" do
    subject(:previous_evidence) { categories_form.previous_evidence }

    let(:evidence) { build(:referral_evidence, referral:) }
    let(:evidences) { [evidence] }
    let(:referral) { create(:referral) }
    let(:categories_form) { described_class.new(referral:, evidence:) }

    before { referral.evidences = evidences }

    it { is_expected.to be_nil }

    context "with a preceding evidence record" do
      let(:other_evidence) { build(:referral_evidence, referral:) }
      let(:evidences) { [other_evidence, evidence] }

      it { is_expected.to eq(other_evidence) }
    end
  end
end
