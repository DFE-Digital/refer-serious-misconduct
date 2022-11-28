require "rails_helper"

RSpec.describe OrganisationAddressForm, type: :model do
  describe "validations" do
    subject { described_class.new(referral:) }

    let(:referral) { build(:referral) }

    it { is_expected.to validate_presence_of(:referral) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:postcode) }
    it { is_expected.to validate_presence_of(:street_1) }
  end

  describe "#valid?" do
    subject(:valid) { form.valid? }

    let(:form) { described_class.new(params) }
    let(:params) do
      {
        city: "London",
        postcode: "W1 1CW",
        referral:,
        street_1: "1 Street",
        street_2: ""
      }
    end
    let(:organisation) { build(:organisation) }
    let(:referral) { organisation.referral }

    it { is_expected.to be_truthy }

    context "when one of the validations is failing" do
      let(:params) { super().merge(street_1: "") }

      it { is_expected.to be_falsy }
    end
  end

  describe "#save" do
    subject(:save) { form.save }

    let(:form) { described_class.new(params) }
    let(:params) do
      {
        city: "London",
        postcode: "W1 1CW",
        referral:,
        street_1: "1 Street",
        street_2: "Extra"
      }
    end
    let(:organisation) { build(:organisation) }
    let(:referral) { organisation.referral }

    before { save }

    it { expect(organisation.city).to eq("London") }
    it { expect(organisation.postcode).to eq("W1 1CW") }
    it { expect(organisation.street_1).to eq("1 Street") }
    it { expect(organisation.street_2).to eq("Extra") }
  end
end
