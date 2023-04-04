require "rails_helper"

RSpec.describe Referrals::Organisation::AddressForm, type: :model do
  describe "validations" do
    subject(:form) { described_class.new(referral:) }

    let(:referral) { build(:referral) }

    it { is_expected.to validate_presence_of(:referral) }

    it { expect(form).to validate_presence_of(:name).with_message("Enter the organisation name") }

    it do
      expect(form).to validate_presence_of(:city).with_message(
        "Enter the town or city of your organisation"
      )
    end

    it do
      expect(form).to validate_presence_of(:postcode).with_message(
        "Enter the postcode of your organisation"
      )
    end

    it do
      expect(form).to validate_presence_of(:street_1).with_message(
        "Enter the first line of your organisation’s address"
      )
    end
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    before { valid }

    let(:form) { described_class.new(params) }
    let(:params) do
      {
        city: "London",
        name: "Organisation Name",
        postcode: "NW1 4NP",
        referral:,
        street_1: "1 Street",
        street_2: ""
      }
    end
    let(:organisation) { build(:organisation) }
    let(:referral) { organisation.referral }

    it { is_expected.to be_truthy }

    context "when postcode is invalid" do
      let(:params) { super().merge(postcode: "Invalid") }

      it { is_expected.to be_falsy }

      it { expect(form.errors[:postcode]).to eq(["Enter a real postcode"]) }
    end
  end

  describe "#save" do
    subject(:save) { form.save }

    let(:form) { described_class.new(params) }
    let(:params) do
      {
        city: "London",
        name: "Organisation Name",
        postcode: "NW1 4NP",
        referral:,
        street_1: "1 Street",
        street_2: "Extra"
      }
    end
    let(:organisation) { build(:organisation) }
    let(:referral) { organisation.referral }

    before { save }

    it { expect(organisation.city).to eq("London") }
    it { expect(organisation.postcode).to eq("NW1 4NP") }
    it { expect(organisation.street_1).to eq("1 Street") }
    it { expect(organisation.street_2).to eq("Extra") }
  end
end
