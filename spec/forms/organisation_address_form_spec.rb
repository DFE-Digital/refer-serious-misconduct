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

    let(:city) { "London" }
    let(:form) do
      described_class.new(referral:, street_1:, street_2:, city:, postcode:)
    end
    let(:organisation) { build(:organisation) }
    let(:postcode) { "W1 1CW" }
    let(:referral) { organisation.referral }
    let(:street_1) { "1 Street" }
    let(:street_2) { "" }

    it { is_expected.to be_truthy }

    context "when one of the validations is failing" do
      let(:street_1) { "" }

      it { is_expected.to be_falsy }
    end
  end

  describe "#save" do
    subject(:save) { form.save }

    let(:city) { "London" }
    let(:form) do
      described_class.new(referral:, street_1:, street_2:, city:, postcode:)
    end
    let(:organisation) { build(:organisation) }
    let(:postcode) { "W1 1CW" }
    let(:referral) { organisation.referral }
    let(:street_1) { "1 Street" }
    let(:street_2) { "Extra" }

    before { save }

    it { expect(organisation.city).to eq(city) }
    it { expect(organisation.postcode).to eq(postcode) }
    it { expect(organisation.street_1).to eq(street_1) }
    it { expect(organisation.street_2).to eq(street_2) }
  end
end
