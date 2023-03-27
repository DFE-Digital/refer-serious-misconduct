require "rails_helper"

RSpec.describe SummaryCardComponent, type: :component do
  subject(:component) { described_class.new(rows:) }

  let(:rows) do
    [
      {
        actions: [
          {
            text: "Change",
            href: "/referrals/89/referrer/name/edit?return_to=%2Freferrals%2F89%2Freview",
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

  before { render_inline(component) }

  it "renders the summary card" do
    expect(page).to have_css("section")
    expect(page).to have_css("dt", text: "Your name")
    expect(page).to have_css("dd", text: "Joe Bloggs")
    expect(page).to have_link "Change", href: "/referrals/89/referrer/name/edit?return_to=%2Freferrals%2F89%2Freview"
    expect(page).to have_css("span.govuk-visually-hidden", text: "your name")
  end
end
