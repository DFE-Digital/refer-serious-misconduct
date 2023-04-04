require "rails_helper"

RSpec.describe ReferralHelper, type: :helper do
  describe "#summary_row" do
    subject(:helper_method) { summary_row(**row) }

    context "when called with a path" do
      let(:user) { referral.user }
      let(:referrer) { referral.referrer }
      let(:referral) { create(:referral, :complete) }

      let(:row) { { path: :referrer_name, label: "label", value: "value" } }

      it "returns a hash with the correct keys" do
        expect(helper_method.keys).to eq %i[actions key value]
      end

      it "returns a hash with the correct values" do
        expect(helper_method).to eq(
          {
            actions: {
              text: "Change",
              href: "/referrals/#{referral.id}/referrer/name/edit?return_to=",
              visually_hidden_text: "label"
            },
            key: {
              text: "label"
            },
            value: {
              text: "value"
            }
          }
        )
      end
    end

    context "when called without a path" do
      let(:row) { { path: nil, label: "label", value: "value" } }

      it "returns a hash with the correct keys" do
        expect(helper_method.keys).to eq %i[actions key value]
      end

      it "returns a hash with the correct values" do
        expect(helper_method).to eq(
          { actions: {}, key: { text: "label" }, value: { text: "value" } }
        )
      end
    end
  end
end
