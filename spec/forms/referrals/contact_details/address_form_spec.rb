require "rails_helper"

RSpec.describe Referrals::ContactDetails::AddressForm, type: :model do
  let(:referral) { Referral.new }
  let(:form) do
    described_class.new(
      referral:,
      address_known:,
      address_line_1:,
      address_line_2:,
      town_or_city:,
      postcode:,
      country:
    )
  end

  let(:address_known) { true }
  let(:address_line_1) { "1428 Elm Street" }
  let(:address_line_2) { "Sunset Boulevard" }
  let(:town_or_city) { "London" }
  let(:postcode) { "NW1 4NP" }
  let(:country) { "United Kingdom" }

  describe "validations" do
    it { is_expected.to validate_presence_of(:referral) }
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    it { is_expected.to be_truthy }

    before { form.save }

    context "when address_known is blank" do
      let(:address_known) { "" }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:address_known]).to eq(
          ["Tell us if you know their home address"]
        )
      end
    end

    context "when address_line_1 is blank" do
      let(:address_line_1) { "" }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:address_line_1]).to eq(
          ["Enter the first line of their address"]
        )
      end
    end

    context "when town_or_city is blank" do
      let(:town_or_city) { "" }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:town_or_city]).to eq(["Enter their town or city"])
      end
    end

    context "when postcode is blank" do
      let(:postcode) { "" }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:postcode]).to eq(["Enter their postcode"])
      end
    end

    context "when postcode is invalid" do
      let(:postcode) { "Postcode" }

      it { is_expected.to be_falsy }

      it "adds an error" do
        expect(form.errors[:postcode]).to eq(["Enter a real postcode"])
      end
    end
  end

  describe "#save" do
    subject(:save) { form.save }

    it "saves the referral" do
      save
      expect(referral.address_known).to be_truthy
      expect(referral.address_line_1).to eq("1428 Elm Street")
      expect(referral.address_line_2).to eq("Sunset Boulevard")
      expect(referral.town_or_city).to eq("London")
      expect(referral.postcode).to eq("NW1 4NP")
      expect(referral.country).to eq("United Kingdom")
    end

    context "when the address is not known" do
      let(:address_known) { false }

      it "saves the address_known and sets the address fields as nil" do
        save
        expect(referral.address_known).to be_falsy
        expect(referral.address_line_1).to be_nil
        expect(referral.address_line_2).to be_nil
        expect(referral.town_or_city).to be_nil
        expect(referral.postcode).to be_nil
        expect(referral.country).to be_nil
      end
    end
  end
end
