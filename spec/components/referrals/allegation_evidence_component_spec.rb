require "rails_helper"

RSpec.describe Referrals::AllegationEvidenceComponent, type: :component do
  subject(:component) { described_class.new(referral:) }

  let(:row_labels) { component.rows.map { |row| row.dig(:key, :text) } }
  let(:row_links) { component.rows.map { |row| row.dig(:actions, :href) } }

  before { render_inline(component) }

  context "without evidence" do
    let(:referral) { create(:referral, :complete) }

    it "renders the has evidence row" do
      expect(page).to have_css("dt", text: "Do you have anything to upload?")
      expect(page).to have_css("dd", text: "No")
      expect(page).to have_link "Change",
                href: "/referrals/#{referral.id}/evidence/start/edit?return_to=%2F"
    end

    it "doesn't render the evidence row" do
      expect(page).not_to have_css("dt", text: "Uploaded evidence")
    end
  end

  context "with evidence" do
    let(:referral) { create(:referral, :complete, :evidence) }

    it "renders rows in the right order" do
      expect(row_labels).to eq(["Do you have anything to upload?", "Uploaded evidence"])
    end

    it "renders the has evidence row" do
      expect(page).to have_css("dt", text: "Do you have anything to upload?")
      expect(page).to have_css("dd", text: "Yes")
      expect(page).to have_css("dt", text: "Uploaded evidence")
      expect(page).to have_css("dd", text: "Yes")
      expect(page).to have_link "Change",
                href: "/referrals/#{referral.id}/evidence/uploaded/edit?return_to=%2F"
    end
  end
end
