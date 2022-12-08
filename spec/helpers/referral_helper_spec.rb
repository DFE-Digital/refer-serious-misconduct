require "rails_helper"

RSpec.describe ReferralHelper, type: :helper do
  let(:evidence) { create(:referral_evidence, referral:) }
  let(:referral) { create(:referral) }

  before { referral.evidences = evidences }

  describe "#evidence_categories_back_link" do
    subject(:link) { helper.evidence_categories_back_link(form) }

    let(:form) { Referrals::Evidence::CategoriesForm.new(referral:, evidence:) }

    context "with previous evidence" do
      let(:mock_session) do
        {
          evidence_back_link:
            "/referrals/#{referral.id}/evidence/#{previous_evidence.id}/categories"
        }
      end

      let(:evidences) { [previous_evidence, evidence] }
      let(:previous_evidence) { create(:referral_evidence, referral:) }

      before { allow(helper).to receive(:session).and_return(mock_session) }

      it "returns a link from the session" do
        expect(link).to eq(
          "/referrals/#{referral.id}/evidence/#{previous_evidence.id}/categories"
        )
      end
    end

    context "without previous evidence" do
      let(:evidences) { [evidence] }

      it { is_expected.to eq("/referrals/#{referral.id}/evidence/uploaded") }
    end
  end

  describe "#evidence_check_answers_link" do
    subject(:link) { helper.evidence_check_answers_link(referral) }

    context "with evidence" do
      let(:evidences) { [evidence] }

      it do
        expect(link).to eq(
          "/referrals/#{referral.id}/evidence/#{evidence.id}/categories"
        )
      end
    end

    context "without evidence" do
      let(:evidences) { [] }

      it { is_expected.to eq("/referrals/#{referral.id}/evidence/start") }
    end
  end
end
