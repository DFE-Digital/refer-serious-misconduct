require "rails_helper"

RSpec.describe Devise::Strategies::OtpAuthenticatable do
  def build_rack_env(params)
    env = Rack::MockRequest.env_for("/strategy-test", params)
    env["devise.allow_params_authentication"] = true
    env
  end

  let(:valid_params) do
    { params: { user: { email: "test@example.com", otp: "123456" } } }
  end

  describe "#valid?" do
    it "is true when given a rack env with the expected data" do
      env = build_rack_env(valid_params)
      strategy = described_class.new(env, :user)
      expect(strategy.valid?).to eq true
    end

    it "is false when otp param is missing" do
      params = { params: { user: { email: "test@example.com" } } }
      env = build_rack_env(params)
      strategy = described_class.new(env, :user)
      expect(strategy.valid?).to eq false
    end

    it "is false when email param is missing" do
      params = { params: { user: { email: "test@example.com" } } }
      env = build_rack_env(params)
      strategy = described_class.new(env, :user)
      expect(strategy.valid?).to eq false
    end
  end
end
