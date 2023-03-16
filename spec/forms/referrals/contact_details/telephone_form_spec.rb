require "rails_helper"

RSpec.describe Referrals::ContactDetails::TelephoneForm, type: :model do
  let(:referral) { create(:referral) }
  let(:form) { described_class.new(referral:, phone_known:, phone_number:) }
  let(:phone_known) { true }
  let(:phone_number) { "07700 900 982" }

  describe "validations" do
    it { is_expected.to validate_presence_of(:referral) }
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    before { valid }

    it { is_expected.to be_truthy }

    context "when phone_known is blank" do
      let(:phone_known) { "" }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:phone_known]).to eq(["Select yes if you know their phone number"])
      end
    end

    context "when phone_number is blank" do
      let(:phone_number) { "" }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:phone_number]).to eq(["Enter their phone number"])
      end
    end

    context "when phone_number is invalid" do
      let(:phone_number) { "name" }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:phone_number]).to eq(
          ["Enter a phone number, like 01632 960 001, 07700 900 982 or +44 808 157 0192"]
        )
      end
    end

    context "when phone_known is false and phone_number is blank" do
      let(:phone_known) { false }
      let(:phone_number) { "" }

      it { is_expected.to be_truthy }
    end
  end

  describe "#save" do
    before { form.save }

    it "saves phone_known" do
      expect(referral.phone_known).to be_truthy
    end

    it "saves phone_number" do
      expect(referral.phone_number).to eq("07700 900 982")
    end

    context "when the phone number is not known" do
      let(:phone_known) { false }

      it "saves phone_known" do
        expect(referral.phone_known).to be_falsy
      end

      it "sets phone_number as nil" do
        expect(referral.phone_number).to be_nil
      end
    end
  end
end
