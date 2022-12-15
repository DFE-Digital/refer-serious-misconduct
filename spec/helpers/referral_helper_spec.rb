require "rails_helper"

RSpec.describe ReferralHelper, type: :helper do
  let(:evidence) { create(:referral_evidence, referral:) }
  let(:referral) { create(:referral) }

  describe "#evidence_categories_back_link" do
    subject(:link) { helper.evidence_categories_back_link(form) }

    let(:form) { Referrals::Evidence::CategoriesForm.new(referral:, evidence:) }

    before { referral.evidences = evidences }

    context "with previous evidence" do
      let(:mock_session) do
        {
          evidence_back_link:
            "/referrals/#{referral.id}/evidence/#{previous_evidence.id}/categories/edit"
        }
      end

      let(:evidences) { [previous_evidence, evidence] }
      let(:previous_evidence) { create(:referral_evidence, referral:) }

      before { allow(helper).to receive(:session).and_return(mock_session) }

      it "returns a link from the session" do
        expect(link).to eq(
          edit_referral_evidence_categories_path(referral, previous_evidence)
        )
      end
    end

    context "without previous evidence" do
      let(:evidences) { [evidence] }

      it { is_expected.to eq(referral_evidence_uploaded_path(referral)) }
    end
  end

  describe "#evidence_check_answers_link" do
    subject(:link) { helper.evidence_check_answers_link(referral) }

    before { referral.evidences = evidences }

    context "with evidence" do
      let(:evidences) { [evidence] }

      it do
        expect(link).to eq(
          edit_referral_evidence_categories_path(referral, evidence)
        )
      end
    end

    context "without evidence" do
      let(:evidences) { [] }

      it { is_expected.to eq(edit_referral_evidence_start_path(referral)) }
    end
  end

  describe "#subsection_path" do
    it "returns the path for a referral subsection" do
      subsection_link =
        helper.subsection_path(referral:, subsection: :personal_details_age)
      expect(subsection_link).to eq(
        "/referrals/#{referral.id}/personal-details/age"
      )
    end

    it "returns the public variant of the path for a referral subsection" do
      allow(referral).to receive(:from_employer?).and_return(false)
      subsection_link =
        helper.subsection_path(referral:, subsection: :personal_details_name)
      expect(subsection_link).to eq(
        "/public-referrals/#{referral.id}/personal-details/name"
      )
    end

    it "includes an action if present" do
      subsection_link =
        helper.subsection_path(
          referral:,
          subsection: :personal_details_age,
          action: :edit
        )
      expect(subsection_link).to eq(
        "/referrals/#{referral.id}/personal-details/age/edit"
      )
    end

    it "includes a return to link" do
      subsection_link =
        helper.subsection_path(
          referral:,
          subsection: :personal_details_age,
          action: :edit,
          return_to: "/foo/bar"
        )
      expect(subsection_link).to eq(
        "/referrals/#{referral.id}/personal-details/age/edit?return_to=#{CGI.escape("/foo/bar")}"
      )
    end
  end
end
