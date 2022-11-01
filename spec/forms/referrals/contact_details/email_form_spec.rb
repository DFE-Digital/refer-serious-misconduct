require "rails_helper"

RSpec.describe Referrals::ContactDetails::EmailForm, type: :model do
  describe "validations" do
    it { is_expected.to validate_presence_of(:referral) }
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    let(:referral) { Referral.new }
    let(:form) { described_class.new(referral:, email_known:, email_address:) }
    let(:email_known) { true }
    let(:email_address) { "name@example.com" }

    it { is_expected.to be_truthy }

    context "when email_known is blank" do
      let(:email_known) { "" }

      it { is_expected.to be_falsy }
    end

    context "when email_address is blank" do
      let(:email_address) { "" }

      it { is_expected.to be_falsy }
    end

    context "when email_address is invalid" do
      let(:email_address) { "name" }

      it { is_expected.to be_falsy }
    end

    context "when email_known is false and email_address is blank" do
      let(:email_known) { false }
      let(:email_address) { "" }

      it { is_expected.to be_truthy }
    end
  end

  describe "#save" do
    subject(:save) { form.save }

    let(:referral) { Referral.new }
    let(:form) do
      described_class.new(
        referral:,
        email_known: true,
        email_address: "name@example.com"
      )
    end

    it "saves the referral" do
      save
      expect(referral.email_known).to be_truthy
      expect(referral.email_address).to eq("name@example.com")
    end
  end
end
