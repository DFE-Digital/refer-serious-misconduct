require "rails_helper"

RSpec.describe SummaryCardComponent, type: :component do
  let(:referral) { create(:referral, :complete) }
  let(:section) { Referrals::Sections::ReferrerDetailsSection.new(referral:) }
  let(:rows) do
    [
      {
        actions: [
          {
            text: "Change",
            href: "/referrals/89/referrer_details/name/edit?return_to=%2Freferrals%2F89%2Freview",
            visually_hidden_text: "your name"
          }
        ],
        key: {
          text: "Your name"
        },
        value: {
          text: "Joe Bloggs"
        }
      }
    ]
  end
  let(:row_links) { component.rows.map { |row| row.dig(:actions, 0, :href) } }

  context "when editable is true" do
    subject(:component) { described_class.new(rows:, section:) }

    before { render_inline(component) }

    it "renders the summary card" do
      expect(page).to have_css("section")
      expect(page).to have_css("dt", text: "Your name")
      expect(page).to have_css("dd", text: "Joe Bloggs")
      expect(page).to have_link "Change",
                href:
                  "/referrals/89/referrer_details/name/edit?return_to=%2Freferrals%2F89%2Freview"
      expect(page).to have_css("span.govuk-visually-hidden", text: "your name")
    end
  end

  context "when editable is false" do
    subject(:component) { described_class.new(rows:, section:, editable: false) }

    it "does not have any action links" do
      expect(row_links.compact).to be_empty
    end
  end
end
