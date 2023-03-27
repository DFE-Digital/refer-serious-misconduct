require "rails_helper"

RSpec.describe AboutYouComponent, type: :component do
  subject(:component) { described_class.new(referral:, user:) }

  let(:user) { create(:user) }

  before { render_inline(component) }

  context "when there is a public referral" do
    let(:referral) { create(:referral, :public) }

    let(:expected_hash) do
      {
        key: {
          text: "Your name"
        },
        value: {
          text: "Not answered"
        },
        actions: [
          {
            text: "Change",
            href: "/public-referrals/#{referral.id}/referrer/name/edit?return_to=%2F",
            visually_hidden_text: "your name"
          }
        ]
      }
    end

    describe "#your_name" do
      it "renders the full name of the referrer" do
        expect(component.your_name).to eq(expected_hash)
      end
    end
  end

  context "when there is an employer referral" do
    let(:referral) { create(:referral, :employer) }

    let(:expected_hash) do
      {
        key: {
          text: "Your name"
        },
        value: {
          text: "Not answered"
        },
        actions: [
          {
            text: "Change",
            href: "/referrals/#{referral.id}/referrer/name/edit?return_to=%2F",
            visually_hidden_text: "your name"
          }
        ]
      }
    end

    describe "#your_name" do
      it "renders the full name of the referrer" do
        expect(component.your_name).to eq(expected_hash)
      end
    end
  end
end
