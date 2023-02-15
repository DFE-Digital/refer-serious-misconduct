require "rails_helper"

RSpec.describe "Rack::Attack initializer", rack_attack: true do
  before { FeatureFlags::FeatureFlag.activate(:service_open) }

  describe "limit_otp_emails throttle" do
    def otp_request
      post "/users/session", params: { user: { email: "test@example.com" } }
    end

    it "rate limits POST requests to the OTP generation endpoint" do
      10.times { otp_request }
      expect(response.status).to eq 302

      otp_request
      expect(response.status).to eq 429
    end
  end
end
