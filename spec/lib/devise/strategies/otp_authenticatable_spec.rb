require "rails_helper"

RSpec.describe Devise::Strategies::OtpAuthenticatable do
  let(:env) do
    env = Rack::MockRequest.env_for("/strategy-test", params)
    env["devise.allow_params_authentication"] = true
    env
  end

  describe "#valid?" do
    subject { strategy.valid? }

    let(:strategy) { described_class.new(env, :user) }

    context "with valid params" do
      let(:params) { { params: { user: { email: "test@example.com", otp: "123456" } } } }

      it { is_expected.to be_truthy }
    end

    context "when the otp param is missing" do
      let(:params) { { params: { user: { email: "test@example.com" } } } }

      it { is_expected.to be_falsey }
    end

    context "when the email param is missing" do
      let(:params) { { params: { user: { otp: "123456" } } } }

      it { is_expected.to be_falsey }
    end
  end
end
