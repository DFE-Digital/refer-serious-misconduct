require "rails_helper"

RSpec.describe Referrals::ContactDetails::EmailForm, type: :model do
  let(:referral) { create(:referral) }
  let(:form) { described_class.new(referral:, email_known:, email_address:) }
  let(:email_known) { true }
  let(:email_address) { "name@example.com" }

  describe "validations" do
    it { is_expected.to validate_presence_of(:referral) }
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    before { valid }

    it { is_expected.to be_truthy }

    context "when email_known is blank" do
      let(:email_known) { "" }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:email_known]).to eq(
          ["Select yes if you know their email address"]
        )
      end
    end

    context "when email_address is blank" do
      let(:email_address) { "" }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:email_address]).to eq(["Enter their email address"])
      end
    end

    context "when email_address is invalid" do
      let(:email_address) { "name" }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:email_address]).to eq(
          [
            "Enter an email address in the correct format, like name@example.com"
          ]
        )
      end
    end

    context "when email_known is false and email_address is blank" do
      let(:email_known) { false }
      let(:email_address) { "" }

      it { is_expected.to be_truthy }
    end
  end

  describe "#save" do
    before { form.save }

    it "saves email_known" do
      expect(referral.email_known).to be_truthy
    end

    it "saves email_address" do
      expect(referral.email_address).to eq("name@example.com")
    end

    context "when the email is not known" do
      let(:email_known) { false }

      it "saves email_known" do
        expect(referral.email_known).to be_falsy
      end

      it "sets email_address as nil" do
        expect(referral.email_address).to be_nil
      end
    end
  end
end
