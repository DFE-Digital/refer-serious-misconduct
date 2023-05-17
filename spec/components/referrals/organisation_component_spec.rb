require "rails_helper"

RSpec.describe Referrals::OrganisationComponent, type: :component do
  subject(:component) { described_class.new(referral:) }

  let(:row_links) { component.rows.map { |row| row.dig(:actions, :href) } }

  let(:organisation) { referral.organisation }

  before { render_inline(component) }

  context "with an employer referral" do
    let(:referral) { create(:referral, :complete) }

    it "renders the organisation row" do
      expect(page).to have_css("dt", text: "Your organisation")

      expect(page).to have_css("dd", text: organisation.name)
      expect(page).to have_css("dd", text: organisation.street_1)
      expect(page).to have_css("dd", text: organisation.street_2)
      expect(page).to have_css("dd", text: organisation.city)
      expect(page).to have_css("dd", text: organisation.postcode)

      expect(page).to have_link "Change",
                href: "/referrals/#{referral.id}/organisation/address/edit?return_to=%2F"
    end
  end
end
