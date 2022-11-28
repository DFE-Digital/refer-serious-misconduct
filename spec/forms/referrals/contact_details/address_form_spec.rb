require "rails_helper"

RSpec.describe Referrals::ContactDetails::AddressForm, type: :model do
  let(:referral) { create(:referral) }
  let(:form) { described_class.new(params) }

  let(:params) do
    {
      address_known: true,
      address_line_1: "1428 Elm Street",
      address_line_2: "Sunset Boulevard",
      country: "United Kingdom",
      postcode: "NW1 4NP",
      referral:,
      town_or_city: "London"
    }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:referral) }

    context "when address is known" do
      subject { form }

      let(:params) { { address_known: true } }

      it { is_expected.to validate_presence_of(:address_line_1) }
      it { is_expected.to validate_presence_of(:town_or_city) }
      it { is_expected.to validate_presence_of(:postcode) }
    end
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    before { valid }

    it { is_expected.to be_truthy }

    context "when address_known is blank" do
      let(:params) { super().merge(address_known: "") }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:address_known]).to eq(
          ["Tell us if you know their home address"]
        )
      end
    end

    context "when address_line_1 is blank" do
      let(:params) { super().merge(address_line_1: "") }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:address_line_1]).to eq(
          ["Enter the first line of their address"]
        )
      end
    end

    context "when town_or_city is blank" do
      let(:params) { super().merge(town_or_city: "") }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:town_or_city]).to eq(["Enter their town or city"])
      end
    end

    context "when postcode is blank" do
      let(:params) { super().merge(postcode: "") }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:postcode]).to eq(["Enter their postcode"])
      end
    end

    context "when postcode is invalid" do
      let(:params) { super().merge(postcode: "Invalid") }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:postcode]).to eq(["Enter a real postcode"])
      end
    end
  end

  describe "#save" do
    before { form.save }

    it "saves address_known" do
      expect(referral.address_known).to be_truthy
    end

    it "saves address_line_1" do
      expect(referral.address_line_1).to eq("1428 Elm Street")
    end

    it "saves address_line_2" do
      expect(referral.address_line_2).to eq("Sunset Boulevard")
    end

    it "saves town_or_city" do
      expect(referral.town_or_city).to eq("London")
    end

    it "saves postcode" do
      expect(referral.postcode).to eq("NW1 4NP")
    end

    it "saves country" do
      expect(referral.country).to eq("United Kingdom")
    end

    context "when the address is not known" do
      let(:params) { super().merge(address_known: false) }

      it "sets the address_known to false" do
        expect(referral.address_known).to be_falsy
      end

      it "sets the address_line_1 to nil" do
        expect(referral.address_line_1).to be_nil
      end

      it "sets the address_line_2 to nil" do
        expect(referral.address_line_2).to be_nil
      end

      it "sets the town_or_city to nil" do
        expect(referral.town_or_city).to be_nil
      end

      it "sets the postcode to nil" do
        expect(referral.postcode).to be_nil
      end

      it "sets the country to nil" do
        expect(referral.country).to be_nil
      end
    end
  end
end
