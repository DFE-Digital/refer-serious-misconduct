require "rails_helper"

RSpec.describe ReferralHelper, type: :helper do
  let(:referral) { create(:referral) }
  let(:evidence) { create(:referral_evidence, referral:) }
  let(:evidences) { [] }

  before { referral.evidences = evidences }

  describe "evidence_categories_back_link" do
    let(:form) { Referrals::Evidence::CategoriesForm.new(referral:, evidence:) }

    context "with previous evidence" do
      let(:previous_evidence) { create(:referral_evidence, referral:) }
      let(:evidences) { [previous_evidence, evidence] }

      it "returns edit categories path for the previous evidence" do
        expect(helper.evidence_categories_back_link(form)).to eq(
          referrals_edit_evidence_categories_path(
            form.referral,
            previous_evidence
          )
        )
      end
    end
    context "without previous evidence" do
      let(:evidences) { [evidence] }

      it "returns evidence uploaded path" do
        expect(helper.evidence_categories_back_link(form)).to eq(
          referrals_evidence_uploaded_path(form.referral)
        )
      end
    end
  end

  describe "evidence_categories_back_link" do
    context "with evidence" do
      let(:evidences) { [evidence] }

      it "returns edit evidence categories path" do
        expect(helper.evidence_confirm_back_link(referral)).to eq(
          referrals_edit_evidence_categories_path(referral, evidence)
        )
      end
    end
    context "without evidence" do
      it "returns edit evidence start path" do
        expect(helper.evidence_confirm_back_link(referral)).to eq(
          referrals_edit_evidence_start_path(referral)
        )
      end
    end
  end
end
