require "rails_helper"

RSpec.describe ReferralHelper, type: :helper do
  let(:evidence) { create(:referral_evidence, referral:) }
  let(:referral) { create(:referral) }

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
