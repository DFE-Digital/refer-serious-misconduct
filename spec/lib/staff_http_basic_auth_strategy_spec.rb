require "rails_helper"

RSpec.describe StaffHttpBasicAuthStrategy do
  subject(:staff_http_basic_auth_strategy) { described_class.new(env) }

  let(:env) { {} }

  describe "#valid?" do
    subject(:valid?) { staff_http_basic_auth_strategy.valid? }

    context "with staff users" do
      before { create(:staff) }

      it { is_expected.to eq(false) }
    end

    context "when feature is active" do
      before { FeatureFlags::FeatureFlag.activate(:staff_http_basic_auth) }

      it { is_expected.to eq(true) }
    end

    context "when there are no staff users" do
      it { is_expected.to eq(true) }
    end
  end

  describe "#store?" do
    subject(:store?) { staff_http_basic_auth_strategy.store? }

    it { is_expected.to eq(false) }
  end

  describe "#authenticate!" do
    before { staff_http_basic_auth_strategy.authenticate! }

    it "halts the strategy" do
      expect(staff_http_basic_auth_strategy).to be_halted
    end

    it "is not successful" do
      expect(staff_http_basic_auth_strategy).not_to be_successful
    end

    it "sets a custom response" do
      expect(staff_http_basic_auth_strategy.custom_response).to eq(
        [
          401,
          {
            "Content-Length" => "0",
            "Content-Type" => "text/plain",
            "WWW-Authenticate" => "Basic realm=\"Application\""
          },
          []
        ]
      )
    end
    # rubocop:enable RSpec/ExampleLength

    context "with valid credentials" do
      let(:env) { { "HTTP_AUTHORIZATION" => "Basic #{Base64.encode64("test:test")}" } }

      it "is successful" do
        expect(staff_http_basic_auth_strategy).to be_successful
      end
    end
  end
end
